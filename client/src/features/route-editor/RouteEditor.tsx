import { useTranslation } from 'react-i18next';

const RouteEditor: React.FC = () => {
  const { t } = useTranslation();
  return (
    <div>
      <h1>{t('routeEditor')}</h1>
    </div>
  );
};

export default RouteEditor;
