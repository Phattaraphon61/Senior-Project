import { useState, useEffect } from 'react';
import PerfectScrollbar from 'react-perfect-scrollbar';
import PropTypes from 'prop-types';
import { format, getDate } from 'date-fns';
import { getData, updatestatus } from "../../api/api";
import { Upload as UploadIcon } from '../../icons/upload';
import {
  Avatar,
  Box,
  Card,
  Checkbox,
  Table,
  TableBody,
  TableCell,
  TableHead,
  TablePagination,
  TableRow,
  Typography,
  Tabs,
  Tab,
  TableContainer,
  Paper,
  styled,
  NativeSelect,
  tableCellClasses,
  FormControl,
  InputLabel,
  InputBase,
  Button,
  Modal,
  TextField,
} from '@mui/material';
import { getInitials } from '../../utils/get-initials';
import { width } from '@mui/system';
const BootstrapInput = styled(InputBase)(({ theme }) => ({
  'label + &': {
    marginTop: theme.spacing(3),
  },
  '& .MuiInputBase-input': {
    borderRadius: 4,
    position: 'relative',
    backgroundColor: theme.palette.background.paper,
    border: '1px solid #ced4da',
    fontSize: 16,
    padding: '10px 26px 10px 12px',
    transition: theme.transitions.create(['border-color', 'box-shadow']),
    // Use the system font instead of the default Roboto font.
    fontFamily: [
      '-apple-system',
      'BlinkMacSystemFont',
      '"Segoe UI"',
      'Roboto',
      '"Helvetica Neue"',
      'Arial',
      'sans-serif',
      '"Apple Color Emoji"',
      '"Segoe UI Emoji"',
      '"Segoe UI Symbol"',
    ].join(','),
    '&:focus': {
      borderRadius: 4,
      borderColor: '#80bdff',
      boxShadow: '0 0 0 0.2rem rgba(0,123,255,.25)',
    },
  },
}));
const style = {
  position: 'absolute',
  top: '50%',
  left: '50%',
  transform: 'translate(-50%, -50%)',
  width: 400,
  bgcolor: 'background.paper',
  textAlign: 'center',
  // border: '2px solid #000',
  // boxShadow: 24,
  p: 4,
};
const columns = [
  {
    id: 'name',
    label: 'ชื่อ',
    minWidth: 170
  },
  {
    id: 'number',
    label: 'เลขบัญชี',
    minWidth: 100
  },
  {
    id: 'bank',
    label: 'ธนาคาร',
    minWidth: 170,
    // align: 'right',

  },
  {
    id: 'total',
    label: 'จำนวนเงิน',
    minWidth: 170,
    // align: 'right',

  },
  {
    id: 'status',
    label: 'สถานะ',
    minWidth: 170,
    // align: 'right',
  },
  {
    id: 'id',
    label: 'ยืนยัน',
    minWidth: 170,
    // align: 'right',
  },
];

function createData(name, number, bank, total, status, id, amount) {
  return { name, number, bank, total, status, id, amount };
}

const rows = [
  createData('ภัทรพล ผิวเรือง', '4078580533', 'ไทยพาณิชย์', "30001", "wait", 1),
  createData('ภัทรพล ผิวเรือง', '4078580533', 'ไทยพาณิชย์', "30002", "wait", 2),
  createData('ภัทรพล ผิวเรือง', '4078580533', 'ไทยพาณิชย์', "30003", "wait", 3),
  createData('ภัทรพล ผิวเรือง', '4078580533', 'ไทยพาณิชย์', "30004", "wait", 4),
];

export const CustomerListResults = ({ customers, ...rest }) => {
  const [page, setPage] = useState(0);
  const [rowsPerPage, setRowsPerPage] = useState(10);
  const [checkbtn, setCheckbtn] = useState([]);
  const [data, setData] = useState([]);
  const [open, setOpen] = useState(false);
  const [detail, setDetail] = useState("");
  const [rejectdata, setRejectdata] = useState();
  const [value, setValue] = useState(0);
  var dictbank = {
    'scb': 'ไทยพาณิชย์',
    'kbank': 'กสิกรไทย',
    'ktb': 'กรุงไทย'
  }


  useEffect(() => {
    getDatafromserver()
  }, []);

  const getDatafromserver = () => {
    setData([])
    const datasend = {
      status: "wait"
    }
    getData(datasend).then((res) => {
      res.data.map((t) => {
        setData(c => [...c, createData(t.bank.name, t.bank.number, dictbank[t.bank.bank], t.amount, t.status, t.id, t.amount)])
      })
    })
  }
  const handleChangePage = (event, newPage) => {
    setPage(newPage);
  };

  const handleChangeRowsPerPage = (event) => {
    setRowsPerPage(+event.target.value);
    setPage(0);
  };

  const handleChange = (event, newValue) => {
    setValue(newValue);
  };
  const updateItem = (id, whichvalue, newvalue) => {
    let index = data.findIndex(x => x.id === id);
    if (index !== -1) {
      let temporaryarray = data.slice();
      temporaryarray[index][whichvalue] = newvalue;
      setData(temporaryarray);
    }
    else {
      console.log('no match');
    }
  }
  const sendDatas = (datas) => {
    if (datas.status == 'approve') {
      const datasend = {
        id: datas.id,
        status: datas.status,
      }
      updatestatus(datasend).then((res) => {
  
        setData(data.filter(item => item.id !== datas.id));
      })
    }
    else {
      const datasend = {
        id: datas.id,
        status: datas.status,
        detail: detail,
        amount: `${datas.amount}`
      }
      updatestatus(datasend).then((res) => {
        console.log(res.data)
        setData(data.filter(item => item.id !== datas.id));
      })
    }
  }

  return (
    <div>
      <Box sx={{
        alignItems: 'center',
        display: 'flex',
        justifyContent: 'space-between',
        flexWrap: 'wrap',
        m: 1
      }}>
        <div></div>
        <Button
          color="primary"
          variant="contained"
          onClick={() => {
            setCheckbtn([])
            getDatafromserver()
          }}
        >
          รีโหลดข้อมูล
        </Button>
      </Box>
      <Modal
        open={open}
        aria-labelledby="modal-modal-title"
        aria-describedby="modal-modal-description"
      >
        <Box sx={style}>
          <Typography id="modal-modal-title" variant="h6" component="h2">
            กรอกรายละเอียด
          </Typography>
          <TextField id="outlined-basic" sx={{ mt: 2, width: "100%" }} label="กรอกรายละเอียด" variant="outlined" onChange={(e) => setDetail(e.target.value)} />
          <Box sx={{ mt: 2 }}>
            <Button
              color="error"
              variant="contained"
              onClick={() => {
                setOpen(false)
              }}
            >
              ยกเลิก
            </Button>
            <Button
              color="success"
              variant="contained"
              onClick={() => {
                setOpen(false)
                sendDatas(rejectdata)
              }}
            >
              ยืนยัน
            </Button>
          </Box>
        </Box>
      </Modal>
      <TableContainer component={Paper}>
        <Table sx={{ minWidth: 650 }} aria-label="simple table">
          <TableHead>
            <TableRow>
              <TableCell>ชื่อ</TableCell>
              <TableCell >เลขบัญชี</TableCell>
              <TableCell >ธนาคาร</TableCell>
              <TableCell >จำนวน</TableCell>
              <TableCell >สถานะ</TableCell>
              <TableCell >ยืนยัน</TableCell>
            </TableRow>
          </TableHead>
          <TableBody>
            {data
              .slice(page * rowsPerPage, page * rowsPerPage + rowsPerPage)
              .map((row) => (
                <TableRow
                  key={row.name}
                  sx={{ '&:last-child td, &:last-child th': { border: 0 } }}
                >
                  <TableCell component="th" scope="row">
                    {row.name}
                  </TableCell>
                  <TableCell >{row.number}</TableCell>
                  <TableCell >{row.bank}</TableCell>
                  <TableCell >{row.total}</TableCell>
                  <TableCell ><FormControl key={row.id}>
                    <NativeSelect
                      input={<BootstrapInput />}
                      defaultValue={row.status}
                      onChange={(e) => {
                        // console.log(e.target.value, row);\
                        if (e.target.value == 'rejected') {
                          setOpen(true)
                          setRejectdata(row)
                        }
                        if (!checkbtn.includes(row.id)) {
                          setCheckbtn(c => [...c, row.id])
                        }
                        if (e.target.value == 'wait') {
                          setCheckbtn([
                            ...checkbtn.slice(0, checkbtn.indexOf(row.id)),
                            ...checkbtn.slice(checkbtn.indexOf(row.id) + 1)
                          ]);
                        }
                        updateItem(row.id, 'status', e.target.value)

                      }}
                    >
                      <option value={'wait'}>wait</option>
                      <option value={'approve'}>approve</option>
                      <option value={'rejected'}>rejected</option>
                    </NativeSelect>
                  </FormControl></TableCell>
                  <TableCell >
                    <Button variant="outlined" size="medium" disabled={!checkbtn.includes(row.id)} onClick={() => sendDatas(row)}>
                      ยืนยัน
                    </Button>
                  </TableCell>
                </TableRow>
              ))}
          </TableBody>
        </Table>
        <TablePagination
          rowsPerPageOptions={[10, 25, 100]}
          component="div"
          count={rows.length}
          rowsPerPage={rowsPerPage}
          page={page}
          onPageChange={handleChangePage}
          onRowsPerPageChange={handleChangeRowsPerPage}
        />
      </TableContainer>
    </div>

  );
}
