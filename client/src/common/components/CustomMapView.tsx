import 'leaflet/dist/leaflet.css';
import { MapContainer, TileLayer } from 'react-leaflet';
import { OnboardingWizard } from '../../modules/onboarding-wizard/components/OnboardingWizard';

const CustomMapView: React.FC = () => (
  <MapContainer
    center={[41.99696314011533, 21.432970823922073]}
    zoom={15}
    scrollWheelZoom={true}
    style={{ height: '100%', width: '100%' }}
  >
    <TileLayer
      attribution='&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
      url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
    />
    <OnboardingWizard></OnboardingWizard>
  </MapContainer>
);

export default CustomMapView;
