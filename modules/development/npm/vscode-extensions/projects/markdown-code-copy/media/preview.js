(function() {
    function addCopyButtons() {
        const codeBlocks = document.querySelectorAll('pre code');
        
        codeBlocks.forEach(function(codeBlock) {
            const pre = codeBlock.parentNode;
            
            // Skip if button already exists
            if (pre.querySelector('.copy-button')) {
                return;
            }
            
            // Create copy button
            const copyButton = document.createElement('button');
            copyButton.className = 'copy-button';
            copyButton.textContent = 'Copy';
            copyButton.type = 'button';
            
            copyButton.addEventListener('click', function() {
                const code = codeBlock.textContent || codeBlock.innerText;
                
                navigator.clipboard.writeText(code).then(function() {
                    copyButton.textContent = 'Copied!';
                    copyButton.classList.add('copied');
                    
                    setTimeout(function() {
                        copyButton.textContent = 'Copy';
                        copyButton.classList.remove('copied');
                    }, 2000);
                }).catch(function(err) {
                    console.error('Failed to copy code: ', err);
                    copyButton.textContent = 'Failed';
                    setTimeout(function() {
                        copyButton.textContent = 'Copy';
                    }, 2000);
                });
            });
            
            pre.appendChild(copyButton);
        });
    }
    
    // Add copy buttons when page loads
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', addCopyButtons);
    } else {
        addCopyButtons();
    }
    
    // Re-add copy buttons when content changes (for dynamic content)
    const observer = new MutationObserver(function(mutations) {
        let shouldUpdate = false;
        mutations.forEach(function(mutation) {
            if (mutation.type === 'childList' && mutation.addedNodes.length > 0) {
                shouldUpdate = true;
            }
        });
        if (shouldUpdate) {
            setTimeout(addCopyButtons, 100);
        }
    });
    
    observer.observe(document.body, {
        childList: true,
        subtree: true
    });
})();