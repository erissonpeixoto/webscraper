import React from 'react';
import { createRoot } from 'react-dom/client';
import App from './App';

document.addEventListener('turbo:load', () => {
  const rootElement = document.getElementById('root');
  if (rootElement) {
    const currentUser = rootElement.dataset.currentUser
      ? JSON.parse(rootElement.dataset.currentUser)
      : null;
    const root = createRoot(rootElement);
    root.render(<App currentUser={currentUser}/>);
  }
});