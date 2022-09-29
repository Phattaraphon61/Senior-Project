import Head from 'next/head';
import Router from 'next/router'
import { useState, useEffect } from 'react';
import { Box, Container, Grid } from '@mui/material';
import { Budget } from '../components/dashboard/budget';
import { LatestOrders } from '../components/dashboard/latest-orders';
import { LatestProducts } from '../components/dashboard/latest-products';
import { Sales } from '../components/dashboard/sales';
import { TasksProgress } from '../components/dashboard/tasks-progress';
import { TotalCustomers } from '../components/dashboard/total-customers';
import { TotalProfit } from '../components/dashboard/total-profit';
import { TrafficByDevice } from '../components/dashboard/traffic-by-device';
import { DashboardLayout } from '../components/dashboard-layout';
import { getdashbord } from "../api/api";
import NextLink from 'next/link';
import { Login } from './login'

const Dashboard = () => {
  const [data, setData] = useState([]);
  const [item, setItem] = useState(null);

  useEffect(() => {
    setItem(window.localStorage.getItem('data'))
    if (window.localStorage.getItem('data') === null) {
      Router.push('/login')
    }
    getdashbord(new Date().getFullYear()).then((res) => {
      setData(res.data)
    })
  }, []);
  return (
    <div>
      {item!== null?
      <>
        <Head>
          <title>
          แดชบอร์ด
          </title>
        </Head>
        <Box
          component="main"
          sx={{
            flexGrow: 1,
            py: 8
          }}
        >
          <Container maxWidth={false}>
            <Grid
              container
              spacing={3}
            >
              <Grid
                item
                lg={3}
                sm={6}
                xl={3}
                xs={12}
              >
                <Budget data={{ "washingtotal": data.dashbordModel ? data.dashbordModel.washingtotal : 0, "elite": "50" }} />
              </Grid>
              <Grid
                item
                xl={3}
                lg={3}
                sm={6}
                xs={12}
              >
                <TotalCustomers data={{ "total": data.userModel ? data.userModel.total + data.withdrawModel.totalwait : 0, "elite": "50" }} />
              </Grid>
              <Grid
                item
                xl={3}
                lg={3}
                sm={6}
                xs={12}
              >
                <TasksProgress data={{ "total": data.withdrawModel ? data.withdrawModel.aprrove : 0 }} />
              </Grid>
              <Grid
                item
                xl={3}
                lg={3}
                sm={6}
                xs={12}
              >
                <TotalProfit sx={{ height: '100%' }} data={{ "user": data.userModel ? data.userModel.user : 0 }} />
              </Grid>
              <Grid
                item
                lg={8}
                md={12}
                xl={9}
                xs={12}
              >
                <Sales data={{ "month": data.month ? data.month : 0, chart: data.chart ? data.chart : 0 }} />
              </Grid>
              <Grid
                item
                lg={4}
                md={6}
                xl={3}
                xs={12}
              >
                <TrafficByDevice sx={{ height: '100%' }} data={{ 'total': data.userModel ? data.userModel.total + data.withdrawModel.totalwait : 50, "withdraw": data.withdrawModel ? data.withdrawModel.total : 50 }} />
              </Grid>
              <Grid
                item
                lg={4}
                md={6}
                xl={3}
                xs={12}
              >
                {/* <LatestProducts sx={{ height: '100%' }} /> */}
              </Grid>
              <Grid
                item
                lg={8}
                md={12}
                xl={9}
                xs={12}
              >
                {/* <LatestOrders /> */}
              </Grid>
            </Grid>
          </Container>
        </Box>
      </>:<div></div>}</div>

  )
}

Dashboard.getLayout = (page) => (
  <DashboardLayout>
    {page}
  </DashboardLayout>
);

export default Dashboard;
