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

let budgetLimits = JSON.parse(localStorage.getItem('budget_limits')) || {
    'Food': 5000,
    'Education': 3000,
    'Transport': 1000,
    'Entertainment': 2000,
    'Hostel': 8000,
    'Other': 2000
};

function saveData() {
    localStorage.setItem('budget_transactions', JSON.stringify(transactions));
    localStorage.setItem('budget_limits', JSON.stringify(budgetLimits));
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
    const categoryTotals = {};

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

        if (tx.amount < 0) {
            totalSpent += Math.abs(tx.amount);
            categoryTotals[tx.category] = (categoryTotals[tx.category] || 0) + Math.abs(tx.amount);
        }
        else totalIncome += tx.amount;
    });

    // Update Summary Stats
    document.querySelectorAll('.stat-value')[0].textContent = `₹${(totalIncome - totalSpent).toLocaleString()}`;
    document.querySelectorAll('.stat-value')[1].textContent = `₹${totalIncome.toLocaleString()}`;
    document.querySelectorAll('.stat-value')[2].textContent = `₹${totalSpent.toLocaleString()}`;

    // Update Health Score
    updateHealthScore(totalSpent, totalIncome);

    // Update Dashboard Progress Bars
    renderDashboardBudgets(categoryTotals);

    // Update Planner Section
    renderBudgets(categoryTotals);

    lucide.createIcons();
}

function renderDashboardBudgets(totals) {
    const dashboardGrid = document.querySelector('#dashboard-section .budget-progress-container');
    if (!dashboardGrid) return;

    dashboardGrid.innerHTML = '';

    Object.keys(budgetLimits).slice(0, 4).forEach(cat => {
        const spent = totals[cat] || 0;
        const limit = budgetLimits[cat];
        const percent = Math.min(100, (spent / limit) * 100);
        const color = percent > 90 ? 'var(--danger)' : (percent > 70 ? 'var(--warning)' : 'var(--primary)');

        dashboardGrid.innerHTML += `
            <div class="budget-progress">
                <div class="progress-info">
                    <span>${cat}</span>
                    <span>₹${spent.toLocaleString()} / ₹${limit.toLocaleString()}</span>
                </div>
                <div class="progress-bar">
                    <div class="progress-fill" style="width: ${percent}%; background: ${color};"></div>
                </div>
            </div>
        `;
    });
}

function renderBudgets(totals) {
    const plannerGrid = document.getElementById('budgetPlannerGrid');
    if (!plannerGrid) return;

    plannerGrid.innerHTML = '';

    Object.keys(budgetLimits).forEach(cat => {
        const spent = totals[cat] || 0;
        const limit = budgetLimits[cat];
        const percent = Math.min(100, (spent / limit) * 100);

        plannerGrid.innerHTML += `
            <div class="card animate-fade">
                <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 1rem;">
                    <div>
                        <h3 style="font-size: 1rem; margin-bottom: 4px;">${cat}</h3>
                        <p style="font-size: 0.8rem; color: var(--text-muted);">Monthly Limit</p>
                    </div>
                    <div style="text-align: right;">
                        <input type="number" value="${limit}" onchange="updateLimit('${cat}', this.value)" 
                            style="width: 80px; padding: 4px; background: rgba(0,0,0,0.2); border: 1px solid var(--glass-border); border-radius: 6px; color: white; text-align: right;">
                    </div>
                </div>
                <div class="progress-bar" style="margin-bottom: 0.5rem;">
                    <div class="progress-fill" style="width: ${percent}%; background: ${percent > 90 ? 'var(--danger)' : 'var(--primary)'};"></div>
                </div>
                <div style="display: flex; justify-content: space-between; font-size: 0.8rem;">
                    <span style="color: ${spent > limit ? 'var(--danger)' : 'var(--text-muted)'}">Spent: ₹${spent.toLocaleString()}</span>
                    <span style="color: var(--text-muted)">Left: ₹${Math.max(0, limit - spent).toLocaleString()}</span>
                </div>
            </div>
        `;
    });
}

function updateLimit(category, value) {
    budgetLimits[category] = parseFloat(value) || 0;
    saveData();
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

// Modal Logic
function toggleModal(show) {
    const modal = document.getElementById('expenseModal');
    modal.style.display = show ? 'flex' : 'none';
    if (show) {
        document.getElementById('itemName').focus();
    }
}

function handleFormSubmit(event) {
    event.preventDefault();
    const name = document.getElementById('itemName').value;
    const amount = document.getElementById('itemAmount').value;
    const category = document.getElementById('itemCategory').value;

    const icons = {
        'Food': 'coffee',
        'Education': 'book',
        'Transport': 'bus',
        'Entertainment': 'tv',
        'Hostel': 'home',
        'Other': 'shopping-bag'
    };

    if (name && amount) {
        transactions.push({
            id: Date.now(),
            name: name,
            date: 'Just now',
            amount: -parseFloat(amount),
            category: category,
            icon: icons[category] || 'shopping-bag'
        });
        saveData();
        toggleModal(false);
        event.target.reset();
    }
}

// Import/Export Logic
function exportData(format = 'json') {
    console.log("Export triggered:", format);
    try {
        let content, fileName, mimeType;

        if (format === 'csv') {
            const headers = ['ID', 'Name', 'Date', 'Amount', 'Category'];
            const rows = transactions.map(tx => [
                tx.id,
                `"${(tx.name || '').replace(/"/g, '""')}"`,
                tx.date,
                tx.amount,
                tx.category
            ].join(','));
            content = "\uFEFF" + [headers.join(','), ...rows].join('\n');
            fileName = 'budget_history.csv';
            mimeType = 'text/csv;charset=utf-8';
        } else {
            content = JSON.stringify(transactions, null, 2);
            fileName = 'budget_data.json';
            mimeType = 'application/json;charset=utf-8';
        }

        const blob = new Blob([content], { type: mimeType });
        const url = URL.createObjectURL(blob);
        const link = document.createElement('a');

        link.href = url;
        link.download = fileName;

        document.body.appendChild(link);
        link.click();

        setTimeout(() => {
            document.body.removeChild(link);
            URL.revokeObjectURL(url);
            console.log("Download cleanup done.");
        }, 500);
    } catch (err) {
        console.error("Export Error:", err);
        alert("Export failed. Check browser console.");
    }
}

function resetApp() {
    if (confirm("Reset current data? This will bring back the default setup.")) {
        localStorage.removeItem('budget_transactions');
        location.reload();
    }
}

function handleImport(input) {
    const file = input.files[0];
    const reader = new FileReader();

    reader.onload = function (e) {
        try {
            const importedData = JSON.parse(e.target.result);
            if (Array.isArray(importedData)) {
                transactions = importedData;
                saveData();
                alert("Successfully imported " + transactions.length + " transactions!");
            }
        } catch (err) {
            alert("Error: Invalid JSON file format.");
        }
    };

    if (file) {
        reader.readAsText(file);
    }
}

// Function to open modal (replacing prompt)
document.querySelector('.primary-btn').addEventListener('click', (e) => {
    // Check if it's the main sidebar button
    if (e.target.closest('aside')) {
        toggleModal(true);
    }
});

// AI Insights Simulation
function getAIInsight() {
    const insights = [
        "You've spent 15% more on Coffee than last week. Consider home brewing!",
        "Your savings are on track for the 'New Laptop' goal. Keep it up!",
        "Student discount alert: Apple Music is available for ₹59/month for you.",
        "Pro Tip: Buying groceries in bulk could save you ₹1,200 this month."
    ];
    alert("🤖 AI Insight: " + insights[Math.floor(Math.random() * insights.length)]);
}

// Initial Render
updateUI();
