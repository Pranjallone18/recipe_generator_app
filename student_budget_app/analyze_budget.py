import json
import os
from datetime import datetime

def analyze_student_budget(file_path):
    print("="*50)
    print("📊 BUDGETCAP DATA ANALYST (PYTHON v1.0)")
    print("="*50)
    
    if not os.path.exists(file_path):
        print(f"❌ Error: File '{file_path}' not found.")
        print("💡 Tip: Export your data from the website as JSON and save it here.")
        return

    with open(file_path, 'r') as f:
        transactions = json.load(f)

    total_income = 0
    total_expense = 0
    categories = {}

    for tx in transactions:
        amount = tx['amount']
        category = tx['category']
        
        if amount > 0:
            total_income += amount
        else:
            total_expense += abs(amount)
            categories[category] = categories.get(category, 0) + abs(amount)

    balance = total_income - total_expense
    savings_rate = (balance / total_income * 100) if total_income > 0 else 0

    print(f"\n📈 Financial Summary ({datetime.now().strftime('%B %Y')}):")
    print(f"   - Total Income:  ₹{total_income:,.2f}")
    print(f"   - Total Expense: ₹{total_expense:,.2f}")
    print(f"   - Net Balance:   ₹{balance:,.2f}")
    print(f"   - Savings Rate:  {savings_rate:.1f}%")

    print("\n🍕 Spending by Category:")
    for cat, amt in categories.items():
        bar = "█" * int((amt / total_expense) * 20)
        print(f"   - {cat:<15}: ₹{amt:>8,.2f} {bar}")

    print("\n🤖 AI Analyst Suggestion:")
    if savings_rate < 10:
        print("   ⚠️ Danger Zone: Your savings rate is low. Check your Food & Entertainment costs!")
    elif total_income < total_expense:
        print("   🚨 Warning: You are spending more than you earn! Reduce discretionary spend.")
    else:
        print("   ✅ Healthy: You are maintaining a good budget. Consider moving surplus to Goals.")

    print("\n" + "="*50)

if __name__ == "__main__":
    # If the user has exported their budget_data.json to this folder:
    analyze_student_budget('budget_data.json')
