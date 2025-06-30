import '@fontsource/ubuntu';
import { createTheme } from '@mui/material';

const globalTheme = createTheme({
  colorSchemes: {
    dark: true,
  },
  typography: {
    fontFamily: '"Ubuntu", "Arial", sans-serif',
  },
});

export default globalTheme;
