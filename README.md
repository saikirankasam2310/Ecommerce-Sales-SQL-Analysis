# Ecommerce-Sales-SQL-Analysis (Expanded)

## Project Overview
This expanded project contains a realistic e-commerce sales dataset (~12,000 rows), advanced SQL queries, and a **Streamlit dashboard** for interactive analysis. It's designed to be portfolio-ready and easy to deploy.

**Key components:**
- Large dataset: `dataset/ecommerce_sales_large.csv`
- Advanced SQL queries: `sql/queries.sql`
- Streamlit app: `streamlit_app/app.py`
- Requirements: `streamlit_app/requirements.txt`

## How to run the Streamlit dashboard locally
1. Ensure you have Python 3.8+ installed.
2. Create a virtual environment (recommended):
   ```bash
   python -m venv venv
   source venv/bin/activate  # macOS/Linux
   venv\Scripts\activate   # Windows PowerShell
   ```
3. Install requirements:
   ```bash
   pip install -r streamlit_app/requirements.txt
   ```
4. From the project root, run:
   ```bash
   streamlit run streamlit_app/app.py
   ```
5. The Streamlit app will open in your browser (http://localhost:8501).

## How to use
- You can upload your own CSV (same schema) or use the included large dataset.
- The dashboard shows KPIs, revenue trends, top products, region distribution, and top customers.
- Use the SQL queries in `sql/queries.sql` to run server-side aggregations in MySQL and power dashboards.

## Deployment
- Deploy the Streamlit app to **Streamlit Cloud** or other hosting providers that support Streamlit. Add `requirements.txt` and point to `streamlit_app/app.py` as the entrypoint.
- For MySQL-backed dashboards, host the DB on a cloud provider and update the Streamlit app to query the DB directly.

## Next steps (for portfolio)
- Add screenshots from the Streamlit dashboard to the README (I included a `screenshots/` folder for you to place images).
- Add a short analysis summary and business recommendations based on the data.

---
**Author:** Saikiran Kasam
**GitHub:** https://github.com/saikirankasam2310
