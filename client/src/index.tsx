import React from 'react';
import ReactDOM from 'react-dom/client';
import App from './app/App';
import { CssBaseline, ThemeProvider } from '@mui/material';
import globalTheme from './theme/theme';
import './translations/i18n'

const rootEl = document.getElementById('root');
if (rootEl) {
  const root = ReactDOM.createRoot(rootEl);
  root.render(
    <React.StrictMode>
      <ThemeProvider theme={globalTheme}>
        <CssBaseline />
        <App />
      </ThemeProvider>
    </React.StrictMode>,
  );
}
