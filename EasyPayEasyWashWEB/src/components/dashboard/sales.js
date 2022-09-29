import { Bar } from 'react-chartjs-2';
import { useState, useEffect } from 'react';
import { Box, Button, Card, CardContent, CardHeader, Divider, useTheme, Stack } from '@mui/material';
import ArrowDropDownIcon from '@mui/icons-material/ArrowDropDown';
import ArrowRightIcon from '@mui/icons-material/ArrowRight';
import TextField from '@mui/material/TextField';
import { AdapterDateFns } from '@mui/x-date-pickers/AdapterDateFns';
import { LocalizationProvider } from '@mui/x-date-pickers/LocalizationProvider';
import { DesktopDatePicker } from '@mui/x-date-pickers/DesktopDatePicker';
import { getdashbord } from "../../api/api"

export const Sales = (props) => {
  const theme = useTheme();
  const [value, setValue] = useState(new Date());
  const [month, setMonth] = useState();
  const [chart, setChart] = useState();
  useEffect(() => {
    setMonth(props.data.month)
    setChart(props.data.chart)
    // getdashbord().then((res) => {
    //   setData(res.data)
    //   console.log(res.data.dashbordModel.washingtotal)
    // })
  }, []);
  const handleChange = (newValue) => {
    setValue(newValue);
  };

  const data = {
    datasets: [
      // {
      //   backgroundColor: '#EEEEEE',
      //   barPercentage: 0.5,
      //   barThickness: 12,
      //   borderRadius: 4,
      //   categoryPercentage: 0.5,
      //   data: [20, 5, 19, 27, 29, 19, 20],
      //   label: 'จำนวนเครื่องซักผ้า',
      //   maxBarThickness: 10
      // },
      {
        backgroundColor: '#3F51B5',
        barPercentage: 0.5,
        barThickness: 12,
        borderRadius: 4,
        categoryPercentage: 0.5,
        data: chart ? chart : props.data.chart,
        label: 'เงินเข้าระบบ',
        maxBarThickness: 10
      }
    ],
    labels: month ? month : props.data.month
  };

  const options = {
    animation: false,
    cornerRadius: 20,
    layout: { padding: 0 },
    legend: { display: false },
    maintainAspectRatio: false,
    responsive: true,
    xAxes: [
      {
        ticks: {
          fontColor: theme.palette.text.secondary
        },
        gridLines: {
          display: false,
          drawBorder: false
        }
      }
    ],
    yAxes: [
      {
        ticks: {
          fontColor: theme.palette.text.secondary,
          beginAtZero: true,
          min: 0
        },
        gridLines: {
          borderDash: [2],
          borderDashOffset: [2],
          color: theme.palette.divider,
          drawBorder: false,
          zeroLineBorderDash: [2],
          zeroLineBorderDashOffset: [2],
          zeroLineColor: theme.palette.divider
        }
      }
    ],
    tooltips: {
      backgroundColor: theme.palette.background.paper,
      bodyFontColor: theme.palette.text.secondary,
      borderColor: theme.palette.divider,
      borderWidth: 1,
      enabled: true,
      footerFontColor: theme.palette.text.secondary,
      intersect: false,
      mode: 'index',
      titleFontColor: theme.palette.text.primary
    }
  };

  return (
    <Card {...props}>
      <CardHeader
        action={(
          // <Button
          //   endIcon={<ArrowDropDownIcon fontSize="small" />}
          //   size="small"
          // >
          //   2022
          // </Button>
          <LocalizationProvider dateAdapter={AdapterDateFns}>
            <Stack spacing={3}>

              <DesktopDatePicker
                // color="palette.primary1Color"
                views={['year']}
                label="เลือกปี"
                inputFormat="yyyy"
                minDate={new Date('2022-01-01')}
                value={value}

                onChange={((e) => {
                  setValue(e);
                  getdashbord(e.getFullYear()).then((res) => {
                    setMonth(res.data.month)
                    setChart(res.data.chart)
                  })
                })}
                renderInput={(params) => <TextField {...params} />}
              />
            </Stack>
          </LocalizationProvider>
        )}
        title="จำนวนเงินเข้าระบบ"
      />
      <Divider />
      <CardContent>
        <Box
          sx={{
            height: 400,
            position: 'relative'
          }}
        >
          <Bar
            data={data}
            options={options}
          />
        </Box>
      </CardContent>
      <Divider />
      <Box
        sx={{
          display: 'flex',
          justifyContent: 'flex-end',
          p: 2
        }}
      >
        {/* <Button
          color="primary"
          endIcon={<ArrowRightIcon fontSize="small" />}
          size="small"
        >
          Overview
        </Button> */}
      </Box>
    </Card>
  );
};
