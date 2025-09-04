import { OnboardingWizard } from '@modules/onboarding-wizard/exports';
import { BrowserRouter, Routes, Route } from 'react-router';

const App = () => (
  <BrowserRouter>
    <Routes>
      <Route path="/" element={<OnboardingWizard />} />
    </Routes>
  </BrowserRouter>
);

export default App;
