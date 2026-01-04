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

// Section Switching Logic
function showSection(sectionId, element) {
    // Hide all sections
    document.querySelectorAll('.page-section').forEach(section => {
        section.style.display = 'none';
    });

    // Show the target section
    const targetSection = document.getElementById(sectionId);
    if (targetSection) {
        targetSection.style.display = 'block';
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
        // Chart.js usually handles ResizeObserver well, but we can trigger it if needed
        window.dispatchEvent(new Event('resize'));
    }
}

// Update Date
document.getElementById('currentDate').textContent = new Date().toLocaleDateString('en-US', {
    month: 'long',
    day: 'numeric',
    year: 'numeric'
});

// Function to simulate adding an expense
document.querySelector('.primary-btn').addEventListener('click', () => {
    const amount = prompt("Enter expense amount (₹):");
    if (amount && !isNaN(amount)) {
        alert(`Successfully added an expense of ₹${amount}! (Simulation)`);
    }
});
