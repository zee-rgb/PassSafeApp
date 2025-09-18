// Share modal functionality - prevents console errors
(function() {
  function initShareModal() {
    // Check if share button exists before adding event listener
    const shareButton = document.getElementById('share-button');
    if (shareButton) {
      shareButton.addEventListener('click', function() {
        // Share functionality here
        // This avoids the error when the element doesn't exist
      });
    }
  }

  // Initialize when DOM is ready
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initShareModal);
  } else {
    initShareModal();
  }
})();
