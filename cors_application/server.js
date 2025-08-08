const express = require('express');
const cors = require('cors');
const { createProxyMiddleware } = require('http-proxy-middleware');

const app = express();

app.use(cors());

app.use('/proxy', (req, res, next) => {
  const target = req.query.url;
  if (!target) {
    return res.status(400).json({ error: 'Missing target URL (url query param)' });
  }

  createProxyMiddleware({
    target,
    changeOrigin: true,
    secure: false,
    onProxyReq: (proxyReq) => {
      proxyReq.setHeader('Access-Control-Allow-Origin', '*');
      proxyReq.setHeader('Access-Control-Allow-Methods', 'GET,POST,PUT,DELETE,OPTIONS');
      proxyReq.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');
    }
  })(req, res, next);
});

app.get('/health', (req, res) => {
  res.json({ status: 'ok', message: 'CORS proxy is running' });
});

const PORT = process.env.PORT || 8080;
app.listen(PORT, () => {
  console.log(`CORS proxy running on port ${PORT}`);
});
