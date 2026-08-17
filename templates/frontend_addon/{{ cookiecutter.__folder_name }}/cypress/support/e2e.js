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
  cy.visit('/cypress/my-page');
  cy.waitForResourceToLoad('my-page');
  cy.navigate('/cypress/my-page/edit');
};

export const slateAfterEach = () => {
  cy.autologin();
  cy.removeContent('cypress');
};
