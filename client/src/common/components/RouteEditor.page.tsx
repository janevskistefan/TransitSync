import { useTranslation } from 'react-i18next';
import 'leaflet/dist/leaflet.css'; // Import Leaflet CSS
import CustomMapView from './CustomMapView';
import { Box } from '@mui/material';

const RouteEditor: React.FC = () => {
  const { t } = useTranslation();
  return (
    <Box width={"80%"} height={"80%"}>
      <h1>{t('routeEditor')}</h1>
      <CustomMapView />
    </Box>
  );
};

export default RouteEditor;
