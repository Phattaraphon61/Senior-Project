import { Avatar, Box, Card, CardContent, Grid, Typography } from '@mui/material';
import ArrowDownwardIcon from '@mui/icons-material/ArrowDownward';
import MoneyIcon from '@mui/icons-material/Money';
import LocalLaundryServiceIcon from '@mui/icons-material/LocalLaundryService';

export const Budget = (props) => (
  <Card
    sx={{ height: '100%' }}
    {...props}
  >
    <CardContent>
      <Grid
        container
        spacing={3}
        sx={{ justifyContent: 'space-between' }}
      >
        <Grid item>
          <Typography
            color="textSecondary"
            gutterBottom
            variant="overline"
          >
            เครื่องซักผ้าทั้งหมด
          </Typography>
          <Typography
            color="textPrimary"
            variant="h4"
          >
            {props.data.washingtotal} เครื่อง
          </Typography>
        </Grid>
        <Grid item>
          <Avatar
            sx={{
              backgroundColor: 'error.main',
              height: 56,
              width: 56
            }}
          >
            <LocalLaundryServiceIcon />
          </Avatar>
          {/* <img src="/static/images/washing.png" width={56} height={56}></img> */}
        </Grid>
      </Grid>
      {/* <Box
        sx={{
          pt: 2,
          display: 'flex',
          alignItems: 'center'
        }}
      >
        <ArrowDownwardIcon color="error" />
        <Typography
          color="error"
          sx={{
            mr: 1
          }}
          variant="body2"
        >
          {props.data.elite}%
        </Typography>
        <Typography
          color="textSecondary"
          variant="caption"
        >
          จากเดือนที่แล้ว
        </Typography>
      </Box> */}
    </CardContent>
  </Card>
);
