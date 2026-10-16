// ***********************************************************
// EEA Cypress support — loaded automatically before test files
// ***********************************************************

import '@cypress/code-coverage/support';
import './commands';

export const slateBeforeEach = (contentType = 'Document') => {
  cy.autologin();
  cy.createContent({
    contentType: 'Document',
    contentId: 'cypress',
    contentTitle: 'Cypress',
  });
  cy.createContent({
    contentType: contentType,
    contentId: 'my-page',
    contentTitle: 'My Page',
    path: 'cypress',
  });
  // Load the edit route directly instead of pushing it through the SPA
  // history: an appHistory push can race with the client hydration, which
  // then settles back on the server-rendered view URL and the edit UI
  // (including the title editor) never mounts.
  cy.visit('/cypress/my-page/edit');
};

export const slateAfterEach = () => {
  cy.autologin();
  cy.removeContent('cypress');
};
