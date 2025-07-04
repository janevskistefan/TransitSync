import { BrowserRouter, Routes, Route } from 'react-router';
import Layout from './Layout';
import RouteEditor from '../components/RouteEditor.page';

const App = () => (
  <BrowserRouter>
    <Routes>
      <Route element={<Layout />}>
        <Route path="/" element={<RouteEditor />} />
      </Route>
    </Routes>
  </BrowserRouter>
);

export default App;
