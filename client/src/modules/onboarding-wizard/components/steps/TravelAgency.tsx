import { Box, TextField, Typography } from '@mui/material';

export const TravelAgency = () => {
  return (
    <Box marginBlock={3} display={'flex'} flexDirection={'column'} gap={2}>
      <Typography variant="h4">Travel Agency Information</Typography>
      <TextField variant="outlined" label="Name"></TextField>
      <TextField variant="outlined" label="URL"></TextField>
      <TextField variant="outlined" label="Timezone"></TextField>
      <TextField variant="outlined" label="Primary Language"></TextField>
      <TextField variant="outlined" label="Phone Number"></TextField>
      <TextField variant="outlined" label="Fare URL"></TextField>
      <TextField variant="outlined" label="Email"></TextField>
    </Box>
  );
};
