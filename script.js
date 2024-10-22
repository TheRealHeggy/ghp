document.addEventListener('DOMContentLoaded', () => {
    const generateButton = document.getElementById('generateButton');
    const resultDiv = document.getElementById('result');

    if (generateButton && resultDiv) {
        generateButton.addEventListener('click', async () => {
            try {
                const [tab] = await chrome.tabs.query({ active: true, currentWindow: true });

                chrome.scripting.executeScript({
                    target: { tabId: tab.id },
                    function: generateAltText
                }, (results) => {
                    if (chrome.runtime.lastError) {
                        resultDiv.textContent = 'Error: ' + chrome.runtime.lastError.message;
                    } else if (results && results[0]) {
                        resultDiv.textContent = `Generated alt text for ${results[0].result} images.`;
                    }
                });
            } catch (error) {
                resultDiv.textContent = 'An error occurred: ' + error.message;
            }
        });
    } else {
        console.error('Required elements not found in the popup HTML');
    }



    async function generateAltText() {
        const getAltTextFromAI = async (imageUrl) => {
            const resp = (await fetch(
                'http://127.0.0.1:5000/api/caption-image',
                {
                    method: 'POST',
                    headers: {
                        'Accept': 'application/json',
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify(
                        {
                            image_url: imageUrl
                        }
                    )
                }
            ));
            return await resp.json()
        }

        const images = document.getElementsByTagName('img');
        let count = 0;

        for (let img of images) {
            if (!img.alt) {
                try {
                    const altText = await getAltTextFromAI(img.src);
                    img.alt = altText['output'];
                    count++;
                } catch (error) {
                    console.error('Error generating alt text:', error);
                }
            }
        }

        return count;
    }

    async function pollForResult(url, token) {
        while (true) {
            const response = await fetch(url, {
                headers: {
                    'Authorization': `Token ${token}`
                }
            });

            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }

            const result = await response.json();

            if (result.status === 'succeeded') {
                return result;
            } else if (result.status === 'failed') {
                throw new Error('Image processing failed');
            }

            // Wait for 1 second before polling again
            await new Promise(resolve => setTimeout(resolve, 1000));
        }
    }
});
