import React from 'react';
import ReactDOM from 'react-dom/client'
import App from './App';

export default function renderApp(element) {
  ReactDOM.createRoot(element).render(
    <React.StrictMode>
      <App />
    </React.StrictMode>
  )
}
