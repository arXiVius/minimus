const termContent = document.getElementById('terminal-content');
const cursor = document.querySelector('.cursor');

const sequence = [
    { text: "minimus bootstrap", type: "input", delay: 100 },
    { text: "\n", type: "input", delay: 300 },
    { text: " _ __ ___  _ _ __ (_)_ __ ___  _   _ ___ \n| '_ ` _ \\| | '_ \\| | '_ ` _ \\| | | / __|\n| | | | | | | | | | | | | | | | |_| \\__ \\\n|_| |_| |_|_|_| |_|_|_| |_| |_|\\__,_|___/\n", type: "output", delay: 10 },
    { text: "minimus bootstrap\n\n", type: "output", delay: 10 },
    { text: "[>] detecting project type...\n", type: "output", delay: 500 },
    { text: "[+] detected: package.json (node.js)\n", type: "output", class: "green", delay: 800 },
    { text: "[>] running npm install...\n", type: "output", delay: 1200 },
    { text: "[+] installed 42 dependencies\n", type: "output", class: "green", delay: 500 },
    { text: "[+] setup complete\n", type: "output", class: "cyan", delay: 500 },
    { text: "\nuser@minimus:~$ ", type: "prompt", delay: 0 }
];

let seqIndex = 0;
let charIndex = 0;

function typeWriter() {
    if (seqIndex >= sequence.length) return;

    const step = sequence[seqIndex];
    
    if (step.type === "input") {
        if (charIndex < step.text.length) {
            termContent.insertBefore(document.createTextNode(step.text.charAt(charIndex)), cursor);
            charIndex++;
            setTimeout(typeWriter, 50 + Math.random() * 50); // Random typing speed
        } else {
            seqIndex++;
            charIndex = 0;
            setTimeout(typeWriter, step.delay);
        }
    } else {
        // Output block (render all at once or line by line, but for output usually instant or chunked)
        const span = document.createElement('span');
        if (step.class) span.className = step.class;
        span.innerText = step.text;
        
        // For multi-line ASCII, preserve format
        if (step.text.includes('_ __')) {
             span.style.color = "var(--cyan)";
        }
        
        termContent.insertBefore(span, cursor);
        seqIndex++;
        setTimeout(typeWriter, step.delay);
    }
}

// Start animation prompt
const promptSpan = document.createElement('span');
promptSpan.className = "prompt";
promptSpan.innerText = "user@minimus:~$ ";
termContent.insertBefore(promptSpan, cursor);

// Start typing
setTimeout(typeWriter, 1000);


// Tab Logic
function showTab(os) {
    // Buttons
    document.querySelectorAll('.tab').forEach(b => b.classList.remove('active'));
    event.target.classList.add('active');

    // Content
    document.getElementById('code-linux').classList.add('hidden');
    document.getElementById('code-windows').classList.add('hidden');
    document.getElementById(`code-${os}`).classList.remove('hidden');
}

function copyCode(id) {
    const el = document.getElementById(id).querySelector('code');
    navigator.clipboard.writeText(el.innerText).then(() => {
        const btn = document.getElementById(id).querySelector('.copy-btn');
        const originalText = btn.innerText;
        btn.innerText = "copied!";
        setTimeout(() => btn.innerText = originalText, 2000);
    });
}
