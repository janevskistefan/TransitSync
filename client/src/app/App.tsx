import { BrowserRouter, Routes, Route } from 'react-router';
import MainLayout from './MainLayout';
import RouteEditor from '../features/route-editor/RouteEditor';

const App = () => {
  return (
    <BrowserRouter>
      <Routes>
        <Route element={<MainLayout />}>
          <Route path="/" element={<RouteEditor />}/>
        </Route>
      </Routes>
    </BrowserRouter>
  );
};

export default App;