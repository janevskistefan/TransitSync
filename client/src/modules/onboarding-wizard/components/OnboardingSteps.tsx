import { TravelAgency } from './steps/TravelAgency';
import BusinessIcon from '@mui/icons-material/Business';
import AddLocationIcon from '@mui/icons-material/AddLocation';
import { Stops } from './steps/Stops';
import RouteIcon from '@mui/icons-material/Route';
import { TransitRoutes } from './steps/TransitRoutes';

type OnboardingStep = {
  id: string;
  title: string;
  // Define type of props for icon and component if needed
  icon: React.ElementType;
  component: React.FC;
};

// TODO: Add translations to titles
export const onboardingSteps: OnboardingStep[] = [
  {
    id: 'travelAgency',
    title: 'Travel Agency Information',
    icon: BusinessIcon,
    component: TravelAgency,
  },
  {
    id: 'stops',
    title: 'Stops',
    icon: AddLocationIcon,
    component: Stops,
  },
  {
    id: 'routes',
    title: 'Routes',
    icon: RouteIcon,
    component: TransitRoutes,
  },
];
