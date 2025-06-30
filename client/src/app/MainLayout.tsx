import React from 'react';
import {
  Box,
  List,
  ListItemButton,
  ListItemIcon,
  IconButton,
  Divider,
  Stack,
  Typography,
} from '@mui/material';
import HomeIcon from '@mui/icons-material/Home';
import DirectionsBusIcon from '@mui/icons-material/DirectionsBus';
import MapIcon from '@mui/icons-material/Map';
import SettingsIcon from '@mui/icons-material/Settings';
import { Outlet, useNavigate, useLocation } from 'react-router-dom';
import { useTranslation } from 'react-i18next';

const SIDEBAR_WIDTH = 60;

const navItems = [
  { label: 'Home', icon: <HomeIcon />, path: '/' },
  { label: 'Routes', icon: <DirectionsBusIcon />, path: '/#' },
  { label: 'Map', icon: <MapIcon />, path: '/##' },
];

const LANGUAGES = [
  { code: 'en', label: 'English', flag: '🇺🇸' },
  { code: 'mk', label: 'Македонски', flag: '🇲🇰' },
];

const Sidebar: React.FC = () => {
  const navigate = useNavigate();
  const location = useLocation();
  const { i18n } = useTranslation();

  return (
    <Box
      width={SIDEBAR_WIDTH}
      height="100vh"
      display="flex"
      flexDirection="column"
      borderRight={1}
      borderColor="divider"
      position="fixed"
      top={0}
      left={0}
      zIndex={1200}
    >
      <Box flex={1}>
        <List>
          {navItems.map((item) => (
            <ListItemButton
              key={item.label}
              selected={location.pathname === item.path}
              onClick={() => navigate(item.path)}
              sx={{ justifyContent: 'center', py: 2 }}
            >
              <ListItemIcon
                sx={{ minWidth: 0, display: 'flex', justifyContent: 'center' }}
              >
                {item.icon}
              </ListItemIcon>
            </ListItemButton>
          ))}
        </List>
      </Box>
      <Divider />
      <Stack spacing={1} py={1} alignItems="center">
        {LANGUAGES.map((lang) => (
          <IconButton
            key={lang.code}
            onClick={() => i18n.changeLanguage(lang.code)}
            color={i18n.language === lang.code ? 'primary' : 'default'}
          >
            <Typography> {lang.flag} </Typography>
          </IconButton>
        ))}
        <IconButton>
          <SettingsIcon />
        </IconButton>
      </Stack>
    </Box>
  );
};

const MainLayout: React.FC = () => (
  <Box display="flex" minHeight="100vh">
    <Sidebar />
    <Box flex={1} ml={`${SIDEBAR_WIDTH}px`} px={3}>
      <Outlet />
    </Box>
  </Box>
);

export default MainLayout;
