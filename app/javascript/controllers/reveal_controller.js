// Reveal controller for handling password and username reveal/hide functionality
document.addEventListener("DOMContentLoaded", function() {
    // Get CSRF token for API requests
    const csrfToken = document.querySelector('meta[name="csrf-token"]')?.content;
    if (!csrfToken) return;

    // Get entry ID from the page
    const entryIdElement = document.getElementById("entry-id");
    if (!entryIdElement) return;

    const entryId = entryIdElement.value;
    if (!entryId) return;

    // Setup username reveal/hide functionality
    setupRevealHide("username", entryId, csrfToken);

    // Setup password reveal/hide functionality
    setupRevealHide("password", entryId, csrfToken);
});

function setupRevealHide(type, entryId, csrfToken) {
    const revealBtn = document.getElementById(`reveal-${type}-btn`);
    const hideBtn = document.getElementById(`hide-${type}-btn`);
    const container = document.getElementById(`${type}-container`);
    let autoHideTimer = null; // Add timer variable for auto-hide feature

    if (!revealBtn || !hideBtn || !container) return;

    // Reveal button click handler
    revealBtn.addEventListener("click", function() {
        fetch(`/en/entries/${entryId}/reveal_${type}`, {
                method: "POST",
                headers: {
                    "X-CSRF-Token": csrfToken,
                    "Content-Type": "application/json",
                    Accept: "application/json",
                },
            })
            .then((response) => response.json())
            .then((data) => {
                const valueElement = document.getElementById(`${type}-value`);
                if (valueElement) {
                    valueElement.textContent = data.value;
                }
                revealBtn.style.display = "none";
                hideBtn.style.display = "inline-block";

                // Set auto-hide timer for 5 seconds
                if (autoHideTimer) {
                    clearTimeout(autoHideTimer);
                }
                autoHideTimer = setTimeout(function() {
                    // Auto-hide after 5 seconds
                    hideBtn.click();
                }, 5000);
            })
            .catch((error) => {
                // Error handling for reveal operation
                // console.error(`Error revealing ${type}:`, error);
            });
    });

    // Hide button click handler
    hideBtn.addEventListener("click", function() {
        // Clear the auto-hide timer if it exists
        if (autoHideTimer) {
            clearTimeout(autoHideTimer);
            autoHideTimer = null;
        }

        fetch(`/en/entries/${entryId}/mask_${type}`, {
                method: "POST",
                headers: {
                    "X-CSRF-Token": csrfToken,
                    "Content-Type": "application/json",
                    Accept: "application/json",
                },
            })
            .then((response) => response.json())
            .then((data) => {
                const valueElement = document.getElementById(`${type}-value`);
                if (valueElement) {
                    valueElement.textContent = "••••••••";
                }
                revealBtn.style.display = "inline-block";
                hideBtn.style.display = "none";
            })
            .catch((error) => {
                // Error handling for mask operation
                // console.error(`Error masking ${type}:`, error);
            });
    });
}