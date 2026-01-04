// Section Switching Logic
function showSection(sectionId, element) {
    console.log("Switching to section:", sectionId);

    // Hide all sections
    const sections = document.querySelectorAll('.page-section');
    sections.forEach(section => {
        section.style.display = 'none';
        section.classList.remove('animate-fade');
    });

    // Show the target section
    const targetSection = document.getElementById(sectionId);
    if (targetSection) {
        targetSection.style.display = 'block';
        targetSection.classList.add('animate-fade');
    } else {
        console.error("Section not found:", sectionId);
    }

    // Update active class in sidebar
    if (element) {
        document.querySelectorAll('nav a').forEach(link => {
            link.classList.remove('active');
        });
        element.classList.add('active');
    }

    // Special case: Re-render Chart if going back to dashboard
    if (sectionId === 'dashboard-section') {
        window.dispatchEvent(new Event('resize'));
    }
}

// Data Management
let transactions = JSON.parse(localStorage.getItem('budget_transactions')) || [
    { id: 1, name: 'Starbucks Coffee', date: 'Today, 10:24 AM', amount: -450.50, category: 'Food', icon: 'coffee' },
    { id: 2, name: 'Freelance Payout', date: 'Yesterday, 4:15 PM', amount: 2500.00, category: 'Income', icon: 'arrow-down-left' },
    { id: 3, name: 'Amazon - Books', date: '2 Jan, 2026', amount: -1200.00, category: 'Education', icon: 'shopping-cart' }
];

function saveData() {
    localStorage.setItem('budget_transactions', JSON.stringify(transactions));
    updateUI();
}

// Initialize Chart.js
const ctx = document.getElementById('spendingChart').getContext('2d');

const spendingChart = new Chart(ctx, {
    type: 'line',
    data: {
        labels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
        datasets: [{
            label: 'Spending',
            data: [45, 30, 65, 20, 85, 120, 40],
            borderColor: '#6366f1',
            backgroundColor: 'rgba(99, 102, 241, 0.1)',
            fill: true,
            tension: 0.4,
            borderWidth: 3,
            pointBackgroundColor: '#6366f1',
            pointBorderColor: '#fff',
            pointBorderWidth: 2,
            pointRadius: 4,
            pointHoverRadius: 6
        }]
    },
    options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
            legend: {
                display: false
            },
            tooltip: {
                backgroundColor: '#1e293b',
                titleColor: '#f8fafc',
                bodyColor: '#f8fafc',
                borderColor: 'rgba(255, 255, 255, 0.1)',
                borderWidth: 1,
                padding: 12,
                displayColors: false,
                callbacks: {
                    label: function (context) {
                        return '₹' + context.parsed.y * 100;
                    }
                }
            }
        },
        scales: {
            y: {
                beginAtZero: true,
                grid: {
                    color: 'rgba(255, 255, 255, 0.05)',
                    drawBorder: false
                },
                ticks: {
                    color: '#94a3b8',
                    callback: function (value) {
                        return '₹' + value * 100;
                    }
                }
            },
            x: {
                grid: {
                    display: false
                },
                ticks: {
                    color: '#94a3b8'
                }
            }
        }
    }
});

// Update Date
document.getElementById('currentDate').textContent = new Date().toLocaleDateString('en-US', {
    month: 'long',
    day: 'numeric',
    year: 'numeric'
});

// Update UI Elements
function updateUI() {
    const list = document.querySelector('.transaction-list');
    const fullList = document.getElementById('fullTransactionList');

    // Clear lists
    list.innerHTML = '';
    if (fullList) fullList.innerHTML = '';

    let totalSpent = 0;
    let totalIncome = 0;

    transactions.forEach(tx => {
        const itemHtml = `
            <div class="transaction-item animate-fade">
                <div class="tx-info">
                    <div class="tx-icon" style="background: ${tx.amount < 0 ? 'rgba(239, 68, 68, 0.1)' : 'rgba(34, 197, 94, 0.1)'}; color: ${tx.amount < 0 ? 'var(--danger)' : 'var(--success)'};">
                        <i data-lucide="${tx.icon}"></i>
                    </div>
                    <div>
                        <div class="tx-name">${tx.name}</div>
                        <div class="tx-date">${tx.date}</div>
                    </div>
                </div>
                <div class="tx-amount" style="color: ${tx.amount < 0 ? 'var(--danger)' : 'var(--success)'};">
                    ${tx.amount < 0 ? '-' : '+'}₹${Math.abs(tx.amount).toLocaleString()}
                </div>
            </div>
        `;

        list.insertAdjacentHTML('afterbegin', itemHtml);
        if (fullList) fullList.insertAdjacentHTML('afterbegin', itemHtml);

        if (tx.amount < 0) totalSpent += Math.abs(tx.amount);
        else totalIncome += tx.amount;
    });

    // Update Summary Stats
    document.querySelectorAll('.stat-value')[0].textContent = `₹${(totalIncome - totalSpent).toLocaleString()}`;
    document.querySelectorAll('.stat-value')[1].textContent = `₹${totalIncome.toLocaleString()}`;
    document.querySelectorAll('.stat-value')[2].textContent = `₹${totalSpent.toLocaleString()}`;

    // Update Health Score
    updateHealthScore(totalSpent, totalIncome);

    lucide.createIcons();
}

function updateHealthScore(spent, income) {
    const ratio = (spent / (income || 1)) * 100;
    let score = Math.max(0, 100 - ratio).toFixed(0);
    const scoreEl = document.getElementById('healthScoreValue');
    if (scoreEl) {
        scoreEl.textContent = score + '%';
        const circle = document.querySelector('.score-circle');
        if (circle) {
            circle.style.background = `conic-gradient(var(--primary) ${score}%, rgba(255,255,255,0.1) 0%)`;
        }
    }
}

// Function to simulate adding an expense
document.querySelector('.primary-btn').addEventListener('click', () => {
    const name = prompt("What did you spend on?");
    const amount = prompt("Enter amount (₹):");

    if (name && amount && !isNaN(amount)) {
        transactions.push({
            id: Date.now(),
            name: name,
            date: 'Just now',
            amount: -parseFloat(amount),
            category: 'Other',
            icon: 'shopping-bag'
        });
        saveData();
    }
});

// AI Insights Simulation
function getAIInsight() {
    const insights = [
        "You've spent 15% more on Coffee than last week. Consider home brewing!",
        "Your savings are on track for the 'New Laptop' goal. Keep it up!",
        "Student discount alert: Apple Musics is available for ₹59/month for you.",
        "Pro Tip: Buying groceries in bulk could save you ₹1200 this month."
    ];
    alert("🤖 AI Insight: " + insights[Math.floor(Math.random() * insights.length)]);
}

// Initial Render
updateUI();
