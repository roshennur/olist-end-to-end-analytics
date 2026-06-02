<table>
  <tr>
    <td><img src="img_logo_erd/logo.png" alt="Olist Logo" width="350"/></td>
    <td><h1>Olist E-Commerce Analytics</h1></td>
  </tr>
</table>
<br>
<br>

<h2 align="center">Project Background</h2>

<p>Olist is a Brazilian retail technology startup founded in 2015 that connects small retailers and major brands to online marketplaces, simplifying store management, logistics, and financial operations. In December 2021, Olist reached unicorn status with a valuation exceeding $1 billion, alongside expanding into financial services such as credit solutions and receivables anticipation for merchants.</p>

<p>In this project, I partner with the Head of Operations to analyze data, extract insights, and deliver actionable recommendations to improve performance across sales, product, and marketing teams.</p>

<h4>North Star Metrics</h4>
<ul>
  <li><strong>Sales Trends:</strong> Focusing on key metrics — revenue, order volume, and AOV — while analyzing trends over time to identify seasonality, peak periods, and overall growth.</li>
  <li><strong>Product Performance:</strong> Analyzing product categories based on sales, revenue, and customer ratings to identify top and underperforming segments.</li>
  <li><strong>Customer Loyalty:</strong> Segmenting customers into loyal and non-loyal groups to assess retention, repeat purchase behavior, and revenue contribution.</li>
  <li><strong>Logistics & Customer Satisfaction:</strong> Examining delivery performance and review scores to understand the impact of shipping delays on customer satisfaction.</li>
</ul>
<br>
<p align="left">
  <img src="img_logo_erd/erd_olist.png" alt="Olist ERD" width="1000" height="600"/>
</p>
<br>

<h2 align="center">Executive Summary</h2>
<p>Olist's growth is driven primarily by increasing order volume rather than higher customer spend, with revenue rising <strong>22.1% YoY</strong> alongside a <strong>21.6% increase in orders</strong>, while AOV remains stable (~R$145–R$175). However, performance is highly concentrated — <strong>62% of revenue</strong> comes from SP, RJ, and MG, and <strong>50% is driven by just seven product categories</strong>. At the same time, customer retention remains a key gap: repeat customers make up only <strong>3% of the base</strong> but generate <strong>5.6% of revenue</strong>, indicating strong upside in loyalty-driven growth. From an operational perspective, delivery performance is a critical issue, with <strong>8% late orders</strong> significantly impacting customer satisfaction, as reflected in <strong>65% of negative reviews</strong> linked to delays.</p>

<p align="left">
  <img src="tableau/tableau_png/1.Sales_Aov_Growth.png" width="1000" height="600"/>
</p>
<br>

<h2 align="center">Insights Deep Dive: Sales Trend</h2>

<p align="left">
  <img src="excel/Sales & Growth.png" width="1000" height="300"/>
  <img src="tableau/tableau_png/1.Sales.png" width="1000" height="600"/>
</p>
<br>
<ul>
  <li>Sales are highly concentrated in key regions, with São Paulo (SP), Rio de Janeiro (RJ), and Minas Gerais (MG) contributing 62% of total revenue. São Paulo alone accounts for 37%, highlighting a strong geographic dependency.</li>
  <li>Olist’s sales follow a clear seasonal trend, with significant peaks in November and December driven by holiday demand, and noticeable declines in February and October during off-peak periods.</li>
  <li>Total sales grew by 22.1%, increasing from 6.9M in 2017 to 8.4M in 2018, closely aligned with a 21.6% rise in order volume (43K to 52K), indicating that growth was primarily driven by increased transaction volume rather than changes in customer spend, despite 2018 being a partial year (through August).</li>
  <li>Total revenue increased steadily from Q3 2016 through Q2 2018, achieving its highest level in Q2 2018, before experiencing a decline in Q3 2018.</li>
  <li>Average Order Value remains relatively stable, fluctuating between approximately R$145 and R$175, with minor seasonal variations. This stability indicates that revenue growth is primarily driven by increased order volume rather than changes in customer spending behavior.</li>
</ul>
<br>
<h2 align="center">Product Performance</h2>

<p align="left">
  <img src="excel/Product Performance.png" width="1000" height="400"/>
  <img src="tableau/tableau_png/2.products_revenue.png" width="1000" height="600"/>
</p>
<br>
<ul>
  <li>Seven product categories—Health & Beauty, Watches & Gifts, Bed & Table, Sports & Leisure, Computers & Accessories, Furniture & Décor, and Housewares—collectively account for 50% of total revenue.</li>
  <li>Despite having the highest AOV at R$1,290 the Computers category represents just 1.5% of total revenue with 177 Total Order nr.</li>
  <li>The Health & Beauty category leads in revenue, contributing R$1.4 million, which represents 9% of total sales.</li>
  <li>Compact Fixed Telephony 16x16cm-F129E4 (R$ 13,664) and Professional Housewares 61x33cm-4CCE7F (R$ 6,929) are biggest contributors to AOV.</li>
</ul>
