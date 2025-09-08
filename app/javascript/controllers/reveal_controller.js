// Reveal controller for handling password and username reveal/hide functionality
document.addEventListener("DOMContentLoaded", function() {
    // Get CSRF token for API requests
    const csrfToken = document.querySelector('meta[name="csrf-token"]') ? .content;
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
                const valueElement = container.querySelector("p");
                if (valueElement) {
                    valueElement.textContent = data.value;
                }
                revealBtn.style.display = "none";
                hideBtn.style.display = "inline-block";
            })
            .catch((error) => {
                console.error(`Error revealing ${type}:`, error);
            });
    });

    // Hide button click handler
    hideBtn.addEventListener("click", function() {
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
                const valueElement = container.querySelector("p");
                if (valueElement) {
                    valueElement.textContent = "••••••••";
                }
                revealBtn.style.display = "inline-block";
                hideBtn.style.display = "none";
            })
            .catch((error) => {
                console.error(`Error masking ${type}:`, error);
            });
    });
}