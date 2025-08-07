// file: server.js
const express = require('express');
const cors = require('cors');
const { createProxyMiddleware } = require('http-proxy-middleware');

const app = express();

// Allow any origin — adjust as needed for security
app.use(cors());

// Proxy endpoint — target is passed via query param
app.use('/proxy', (req, res, next) => {
  const target = req.query.url;
  if (!target) {
    return res.status(400).json({ error: 'Missing target URL (url query param)' });
  }

  // Dynamically create a proxy for this request
  createProxyMiddleware({
    target,
    changeOrigin: true,
    secure: false, // allow self-signed certs
    onProxyReq: (proxyReq) => {
      proxyReq.setHeader('Access-Control-Allow-Origin', '*');
      proxyReq.setHeader('Access-Control-Allow-Methods', 'GET,POST,PUT,DELETE,OPTIONS');
      proxyReq.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');
    }
  })(req, res, next);
});

const PORT = process.env.PORT || 8080;
app.listen(PORT, () => {
  console.log(`CORS proxy running on port ${PORT}`);
});
