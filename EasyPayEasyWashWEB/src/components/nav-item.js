import NextLink from 'next/link';
import { useState, useEffect } from 'react';
import { useRouter } from 'next/router';
import PropTypes from 'prop-types';
import { Box, Button, ListItem, Typography } from '@mui/material';
import Modal from '@mui/material/Modal';
import Router from 'next/router'

const style = {
  position: 'absolute',
  top: '50%',
  left: '50%',
  transform: 'translate(-50%, -50%)',
  width: 400,
  bgcolor: 'background.paper',
  border: '2px solid #000',
  // boxShadow: 24,
  textAlign: 'center',
  p: 4,
};

export const NavItem = (props) => {
  const [open, setOpen] = useState(false);
  const handleOpen = () => setOpen(true);
  const handleClose = () => setOpen(false);
  const { href, icon, title, ...others } = props;
  const router = useRouter();
  const active = href ? (router.pathname === href) : false;

  return (<div>
    <Modal
      open={open}
      onClose={handleClose}
      aria-labelledby="modal-modal-title"
      aria-describedby="modal-modal-description"
    >
      <Box sx={style}>
        <Typography id="modal-modal-title" variant="h6" component="h2">
          ออกจากระบบ
        </Typography>
        <Typography id="modal-modal-description" sx={{ mt: 2 }}>
          กรุณากดยืนยันเพื่อออกจากระบบ
        </Typography>
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
              window.localStorage.clear();
              Router.push('/login')
            }}
          >
            ยืนยัน
          </Button>
        </Box>
      </Box>
    </Modal>
    <ListItem
      disableGutters
      sx={{
        display: 'flex',
        mb: 0.5,
        py: 0,
        px: 2
      }}
      {...others}
    >{title == 'ออกจากระบบ' ?

      <Button
        onClick={() => setOpen(true)}
        component="a"
        startIcon={icon}
        disableRipple
        sx={{
          backgroundColor: active && '',
          borderRadius: 1,
          color: active ? 'secondary.main' : 'error.main',
          fontWeight: active && 'fontWeightBold',
          justifyContent: 'flex-start',
          px: 3,
          textAlign: 'left',
          textTransform: 'none',
          width: '100%',
          '& .MuiButton-startIcon': {
            color: active ? 'secondary.main' : 'error.main'
          },
          '&:hover': {
            backgroundColor: 'rgba(255,255,255, 0.08)'
          }
        }}
      >
        <Box sx={{ flexGrow: 1 }} >
          {title}
        </Box>
      </Button> : <NextLink
        href={href}
        passHref
      >
        <Button
          component="a"
          startIcon={icon}
          disableRipple
          sx={{
            backgroundColor: active && 'rgba(255,255,255, 0.08)',
            borderRadius: 1,
            color: active ? 'secondary.main' : 'neutral.300',
            fontWeight: active && 'fontWeightBold',
            justifyContent: 'flex-start',
            px: 3,
            textAlign: 'left',
            textTransform: 'none',
            width: '100%',
            '& .MuiButton-startIcon': {
              color: active ? 'secondary.main' : 'neutral.300'
            },
            '&:hover': {
              backgroundColor: 'rgba(255,255,255, 0.08)'
            }
          }}
        >
          <Box sx={{ flexGrow: 1 }} >
            {title}
          </Box>
        </Button>
      </NextLink>}
    </ListItem>
  </div>

  );
};

NavItem.propTypes = {
  href: PropTypes.string,
  icon: PropTypes.node,
  title: PropTypes.string
};