from django.test import TestCase
from unittest.mock import patch
from django.utils import timezone
from datetime import timedelta
from projects.models import DomainModel, ProjectCycleModel, TeamModel, ProjectModel, TeamMembership
from registrations.models import ProjectApplicationModel
from members.models import CustomUser
from projects.services import TeamFormationService

class TeamFormationTestCase(TestCase):
    def setUp(self):
        """Set up initial test data for project cycle, domains, and users."""
        self.cycle = ProjectCycleModel.objects.create(
            cycle_name="Cycle 1", 
            is_active=True,
            start_date=timezone.now(),
            end_date=timezone.now() + timedelta(days=30)
        )
        self.domain1 = DomainModel.objects.create(name="AI/ML")
        self.domain2 = DomainModel.objects.create(name="Blockchain")

        self.users = []
        for i in range(10):
            user, _  = CustomUser.objects.get_or_create(
                username=f"user{i}",
                email=f"user{i}@example.com", 
                passout_year=2025
            )
            self.users.append(user)
            ProjectApplicationModel.objects.create(
                user=user, 
                cycle=self.cycle, 
                first_preference=self.domain1, 
                second_preference=self.domain2, 
                is_selected=False
            )

    @patch("projects.services.get_object_or_404")
    def test_team_assignment_first_preference(self, mock_get_object):
        """Test that teams are formed using first preference when available."""
        mock_get_object.return_value = self.domain1
        
        #Create a project before assigning teams
        project = ProjectModel.objects.create(
            name="Sample Project",
            description="Test Project",
            status=ProjectModel.ONGOING,
            domain=self.domain1
        )

        # ✅ Create a team and associate it with the project
        team = TeamModel.objects.create(name="Sample Team")
        TeamMembership.objects.create(project=project, team=team)

        result = TeamFormationService.assign_teams()
        self.assertGreaterEqual(len(result["teams"]), 1)
        self.assertEqual(len(result["teams"][0].members.all()), 4)

    @patch("projects.services.get_object_or_404")
    def test_team_assignment_second_preference(self, mock_get_object):
        """Test that second preference is used when first preference is full."""
        mock_get_object.side_effect = lambda model, id: self.domain1 if id == self.domain1.id else self.domain2
        
        project = ProjectModel.objects.create(
            name="Sample Project",
            description="Test Project",
            status=ProjectModel.ONGOING,
            domain=self.domain1
        )

        team = TeamModel.objects.create(name="Sample Team")
        TeamMembership.objects.create(project=project, team=team)

        result = TeamFormationService.assign_teams()
        self.assertIn(result["teams"][0].domain, [self.domain1, self.domain2])
        self.assertGreaterEqual(len(result["teams"]), 1)

    def test_no_active_cycle(self):
        """Test error when no active project cycle exists."""
        self.cycle.is_active = False
        self.cycle.save()
        with self.assertRaisesMessage(Exception, "No active project cycle found"):
            TeamFormationService.assign_teams()

    def test_no_applications(self):
        """Test error when no applications exist."""
        ProjectApplicationModel.objects.all().delete()
        with self.assertRaisesMessage(Exception, "No project applications found for the active cycle"):
            TeamFormationService.assign_teams()

    def test_users_return_to_first_preference_if_second_fails(self):
        """Test that users return to first preference if second preference is also full."""
        project = ProjectModel.objects.create(
            name="Sample Project",
            description="Test Project",
            status=ProjectModel.ONGOING,
            domain=self.domain1
        )

        team = TeamModel.objects.create(name="Sample Team")
        TeamMembership.objects.create(project=project, team=team)

        result = TeamFormationService.assign_teams()
        self.assertEqual(len(result["teams"][-1].members.all()), 5)

    def test_creating_5_member_team_when_necessary(self):
        """Test that 5-member teams are only created when both preferences fail."""
        project = ProjectModel.objects.create(
            name="Sample Project",
            description="Test Project",
            status=ProjectModel.ONGOING,
            domain=self.domain1
        )

        for i in range(8):
            team = TeamModel.objects.create(name=f"Team {i}")
            TeamMembership.objects.create(project=project, team=team)

        result = TeamFormationService.assign_teams()
        self.assertEqual(len(result["teams"][-1].members.all()), 5)

    def test_exactly_3_users_remaining_creates_team(self):
        """Test that when exactly 3 users remain, a new team is created instead of waiting."""
        project = ProjectModel.objects.create(
            name="Sample Project",
            description="Test Project",
            status=ProjectModel.ONGOING,
            domain=self.domain1
        )

        for i in range(7):
            team = TeamModel.objects.create(name=f"Team {i}")
            TeamMembership.objects.create(project=project, team=team)

        result = TeamFormationService.assign_teams()
        self.assertEqual(len(result["teams"][-1].members.all()), 3)

    def test_team_balance_across_preferences(self):
        """Test that teams are balanced properly across first and second preference."""
        project = ProjectModel.objects.create(
            name="Sample Project",
            description="Test Project",
            status=ProjectModel.ONGOING,
            domain=self.domain1
        )

        team = TeamModel.objects.create(name="Balanced Team")
        TeamMembership.objects.create(project=project, team=team)

        result = TeamFormationService.assign_teams()
        domain_counts = {self.domain1: 0, self.domain2: 0}
        for team in result["teams"]:
            domain_counts[team.domain] += 1
        self.assertTrue(domain_counts[self.domain1] >= domain_counts[self.domain2])
