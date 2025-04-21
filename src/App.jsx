import './App.css'

import { Card, Typography } from 'antd';

const { Title, Text } = Typography;

function App() {
  return (
    <Card style={{ 
  width: 600,
  background: 'linear-gradient(135deg, #1a1a2e 0%, #16213e 100%)',
  color: '#fff',
  borderRadius: '16px',
  boxShadow: '0 8px 32px rgba(0, 0, 0, 0.3)',
  border: 'none',
  transition: 'all 0.5s cubic-bezier(0.25, 0.8, 0.25, 1)',
  transform: 'translateY(0)',
  position: 'relative',
  overflow: 'hidden',
  '&:hover': {
    transform: 'translateY(-5px)',
    boxShadow: '0 12px 40px rgba(58, 108, 255, 0.3)',
    background: 'linear-gradient(135deg, #1a1a2e 0%, #1e3a8a 100%)',
    '&::before': {
      content: '""',
      position: 'absolute',
      top: 0,
      left: 0,
      right: 0,
      bottom: 0,
      borderRadius: '16px',
      background: 'radial-gradient(circle at 50% 0%, rgba(255,255,255,0.2) 0%, transparent 60%)',
      opacity: 1,
      transition: 'opacity 0.3s ease'
    },
    '&::after': {
      content: '""',
      position: 'absolute',
      top: '10px',
      left: '10px',
      right: '10px',
      bottom: '10px',
      borderRadius: '8px',
      background: 'rgba(255,255,255,0.05)',
      zIndex: -1
    },
    '& .ant-typography': {
      textShadow: '0 0 8px rgba(88, 166, 255, 0.7)'
    }
  },
  '&::after': {
    content: '""',
    position: 'absolute',
    top: 0,
    left: 0,
    right: 0,
    height: '4px',
    background: 'linear-gradient(90deg, #58a6ff, #3a6cff)',
    opacity: 0.8
  }
}}>
      <Title level={2} style={{ textAlign: 'center', color: '#fff', textShadow: '0 2px 4px rgba(0,0,0,0.5)' }}>个人名片</Title>
      <div style={{ marginBottom: '1.5rem' }}>
        <Text strong style={{ color: '#58a6ff' }}>姓名</Text>
        <Text style={{ color: '#fff' }}>张三</Text>
      </div>
      <div style={{ marginBottom: '1.5rem' }}>
        <Text strong style={{ color: '#58a6ff' }}>职业</Text>
        <Text style={{ color: '#fff' }}>前端开发工程师</Text>
      </div>
      <div style={{ marginBottom: '1.5rem' }}>
        <Text strong style={{ color: '#58a6ff' }}>联系方式</Text>
        <Text style={{ color: '#fff' }}>email@example.com</Text>
        <Text style={{ color: '#fff' }}>123-4567-8910</Text>
      </div>
    </Card>
  )
}

export default App
