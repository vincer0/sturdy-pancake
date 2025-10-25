document.addEventListener("DOMContentLoaded", function () {
    Advertisement.init();
});

const Advertisement = (() => {
    const init = () => {
        initalizeImageLead();
        trackVisit();
    };

    const initalizeImageLead = () => {
        const leadImageElement = document.querySelector(".adv-lead-image");

        if (leadImageElement) {
            leadImageElement.addEventListener("click", handleLeadImageClick);
        }
    };

    const handleLeadImageClick = () => {
        const leadAttrName = "data-lead-url";
        const adContainer = document.querySelector(`div[${leadAttrName}]`);

        if (!adContainer) return null;

        const url = adContainer.getAttribute(leadAttrName);

        if (url) {
            fetch(url);
        }
    };

    const trackVisit = () => {
        const trackAttrName = "data-track-url";
        const adContainer = document.querySelector(`div[${trackAttrName}]`);

        if (!adContainer) return null;

        const url = adContainer.getAttribute(trackAttrName);

        if (url) {
            fetch(url);
        }
    };

    return {
        init,
    };
})();
