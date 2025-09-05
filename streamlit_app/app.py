import streamlit as st
import pandas as pd
import numpy as np
from datetime import datetime
import plotly.express as px

st.set_page_config(page_title='Ecommerce Sales Dashboard', layout='wide')

st.title('Ecommerce Sales - Interactive Dashboard')
st.markdown('Upload `ecommerce_sales_large.csv` or use the included dataset to explore KPIs and charts.')

@st.cache_data
def load_data(path):
    df = pd.read_csv(path, parse_dates=['OrderDate'])
    return df

uploaded = st.file_uploader('Upload CSV (optional)', type=['csv'])
if uploaded:
    df = load_data(uploaded)
else:
    df = load_data('dataset/ecommerce_sales_large.csv')

# Basic cleaning
df['OrderDate'] = pd.to_datetime(df['OrderDate'])
df['Year'] = df['OrderDate'].dt.year
df['Month'] = df['OrderDate'].dt.to_period('M').astype(str)

# KPIs
total_revenue = df['TotalAmount'].sum()
total_orders = len(df)
total_customers = df['CustomerID'].nunique()
avg_order_value = round(df['TotalAmount'].mean(),2)

col1, col2, col3, col4 = st.columns(4)
col1.metric('Total Revenue', f'₹{int(total_revenue):,}')
col2.metric('Total Orders', f'{total_orders:,}')
col3.metric('Total Customers', f'{total_customers:,}')
col4.metric('Avg Order Value', f'₹{avg_order_value:,}')

st.markdown('---')

# Revenue over time
rev_time = df.groupby('Month')['TotalAmount'].sum().reset_index()
fig1 = px.line(rev_time, x='Month', y='TotalAmount', title='Revenue by Month')
st.plotly_chart(fig1, use_container_width=True)

# Top products
top_products = df.groupby(['ProductID','ProductName'])['TotalAmount'].sum().reset_index().sort_values('TotalAmount', ascending=False).head(10)
fig2 = px.bar(top_products, x='ProductName', y='TotalAmount', title='Top 10 Products by Revenue')
st.plotly_chart(fig2, use_container_width=True)

# Region-wise revenue
region_rev = df.groupby('Region')['TotalAmount'].sum().reset_index().sort_values('TotalAmount', ascending=False)
fig3 = px.pie(region_rev, names='Region', values='TotalAmount', title='Revenue by Region')
st.plotly_chart(fig3, use_container_width=True)

# Payment method trends
pay = df.groupby('PaymentMethod')['TotalAmount'].agg(['count','sum']).reset_index().rename(columns={'count':'Orders','sum':'Revenue'})
st.dataframe(pay)

# Top customers table
top_customers = df.groupby(['CustomerID','CustomerName'])['TotalAmount'].sum().reset_index().sort_values('TotalAmount', ascending=False).head(15)
st.subheader('Top 15 Customers by Spend')
st.dataframe(top_customers)

# Download sample filtered data
@st.cache_data
def convert_df(df):
    return df.to_csv(index=False).encode('utf-8')

st.download_button('Download Filtered Data (CSV)', convert_df(df), file_name='filtered_ecommerce.csv', mime='text/csv')

st.markdown('---')
st.markdown('**Notes:** This dashboard is generated from the CSV. For production, connect to a database (MySQL) and use the SQL queries for pre-aggregated KPIs.')
