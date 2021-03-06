--转卖余额信息  TBIEE_SALE_YE_FACT
--shenzl  2014-04-08

-- 纸票转贴现转余额查询
 SELECT 
 B.PROD_NO AS PROD_NO,
 (CASE 
		WHEN B.PROD_NO = '127270' THEN '3'   --即期回购卖出+远期卖断
		WHEN B.PROD_NO IN ('127120','127220','127290') THEN '4' --回购式
		WHEN B.PROD_NO = '127230' THEN '5' --卖断式再贴现
		WHEN B.PROD_NO = '127250' THEN '6' --回购式再贴现
		ELSE '7'  --其它
		END) AS PROD_TYPE,
 B.ACCT_BRANCH_NO AS BRCH_NO, NULL AS DEPT_NO,
 B.MAGR_NO AS MAGR_NO,
 (SELECT SUBSTR(WORKDAY,0,4) || '-' || SUBSTR(WORKDAY,5,2) || '-' || SUBSTR(WORKDAY,7) FROM T_BUSI_DATE) AS YE_DT_STR,
 (SELECT TO_DATE(WORKDAY,'yyyyMMdd') FROM T_BUSI_DATE ) AS YE_DT,
 TO_DATE(B.SALE_DT,'yyyy-MM-dd') AS SALE_DT,
 A.TRANS_ID AS TRANS_ID,B.CUST_NO AS CUST_NO,
 A.IS_SAME_CITY AS LO_CODE,B.IS_INNER AS IO_CODE,
 A.IS_ACCP AS IS_SELF_ACCP,NULL AS IS_BUY_BEFORE,TO_DATE(B.REDEEM_END_DT,'yyyy-MM-dd') AS BUSI_DUE_DT,B.RATE AS RATE,B.RATE_TYPE AS RATE_TYPE,A.INTEREST_CAL_DAYS AS RATE_DAYS,
 NULL AS TAX,NULL AS PROFIT,A.BILL_NO AS BILL_NO,A.BILL_TYPE AS BILL_TYPE_CODE,'1' AS BILL_CLASS_CODE,A.BILL_MONEY AS BILL_MONEY,
 TO_DATE(A.ACPT_DT,'yyyy-MM-dd') AS BILL_ACPT_DT,
 TO_DATE(A.DUE_DT,'yyyy-MM-dd') AS BILL_DUE_DT,
 NULL AS BILL_ACPT_CUST_ID,(SELECT ACCEPTOR FROM TP_BILL_INFO WHERE ID=A.BILL_ID) AS BILL_ACPT_CUST_NAME,(SELECT ACCEPTOR_BANK_NO FROM TP_BILL_INFO WHERE ID=A.BILL_ID) AS BILL_ACPT_BANK_NO,
 A.INTEREST AS INTEREST,
 D.PROV_INTEREST AS DRAW_INTEREST,D.REMA_INTEREST AS NO_DRAW_INTEREST,
 A.REMITTER AS BILL_REMITTER_NAME, A.REMITTER_ACCT_NO AS BILL_REMITTER_ACCT,
 (SELECT REMITTER_BANK_NO FROM TP_BILL_INFO WHERE ID=A.BILL_ID) AS BILL_REMITTER_BANK_NO, 
 (SELECT PAYEE FROM TP_BILL_INFO WHERE ID=A.BILL_ID) AS BILL_PAYEE_NAME, 
 (SELECT PAYEE_ACCT_NO FROM TP_BILL_INFO WHERE ID=A.BILL_ID) AS BILL_PAYEE_ACCT, 
 (SELECT PAYEE_BANK_NO FROM TP_BILL_INFO WHERE ID=A.BILL_ID) AS BILL_PAYEE_BANK_NO, 
 (SELECT PAYEE_BANK_NAME FROM TP_BILL_INFO WHERE ID=A.BILL_ID) AS BILL_PAYEE_BANK_NAME, 
 (SELECT DRAWEE_BANK_NO FROM TP_BILL_INFO WHERE ID=A.BILL_ID) AS BILL_DRAWEE_BANK_NO,
 (SELECT DRAWEE_BANK_NAME FROM TP_BILL_INFO WHERE ID=A.BILL_ID) AS BILL_DRAWEE_BANK_NAME,
 B.IS_USE_CONTRACT AS IS_USE_CONTRACT
 
 FROM T_ACCT_HISTORY C,T_PROVISION D,TP_SALE_BILL_INFO A LEFT JOIN TP_SALE_BILL_BATCH B ON A.BATCH_ID=B.ID
WHERE A.ID=C.LIST_ID AND D.LIST_ID=C.LIST_ID AND SUBSTR(C.PROD_NO,1,3)='127' AND C.STATUS='1' 

UNION ALL

-- 电票转贴现转出余额查询
 SELECT B.PROD_NO AS PROD_NO,
 (CASE 
		WHEN B.PROD_NO IN ('227120','227220') THEN '4' --回购式
		WHEN B.PROD_NO = '227230' THEN '5' --卖断式再贴现
		WHEN B.PROD_NO = '227250' THEN '6' --回购式再贴现
		ELSE '7'  --其它
		END) AS PROD_TYPE,
 B.ACCT_BRANCH_NO AS BRCH_NO, NULL AS DEPT_NO,
 B.MAGR_NO AS MAGR_NO,
 (SELECT SUBSTR(WORKDAY,0,4) || '-' || SUBSTR(WORKDAY,5,2) || '-' || SUBSTR(WORKDAY,7) FROM T_BUSI_DATE) AS YE_DT_STR,
 (SELECT TO_DATE(WORKDAY,'yyyyMMdd') FROM T_BUSI_DATE ) AS YE_DT,
 TO_DATE(B.SALE_DT,'yyyy-MM-dd') AS SALE_DT,
 A.TRANS_ID AS TRANS_ID,B.CUST_NO AS CUST_NO,
 NULL AS LO_CODE,B.IS_INNER AS IO_CODE,
 A.IS_ACCP AS IS_SELF_ACCP,NULL AS IS_BUY_BEFORE,TO_DATE(B.REDEEM_END_DT,'yyyy-MM-dd') AS BUSI_DUE_DT,B.RATE AS RATE,B.RATE_TYPE AS RATE_TYPE,A.INTEREST_CAL_DAYS AS RATE_DAYS,
 NULL AS TAX,NULL AS PROFIT,A.BILL_NO AS BILL_NO,A.BILL_TYPE AS BILL_TYPE_CODE,'2' AS BILL_CLASS_CODE,A.BILL_MONEY AS BILL_MONEY,
 TO_DATE(A.ACPT_DT,'yyyy-MM-dd') AS BILL_ACPT_DT,
 TO_DATE(A.DUE_DT,'yyyy-MM-dd') AS BILL_DUE_DT,
 NULL AS BILL_ACPT_CUST_ID,(SELECT ACCEPTOR FROM TE_BILL_INFO WHERE ID=A.BILL_ID) AS BILL_ACPT_CUST_NAME,(SELECT ACCEPTOR_BANK_NO FROM TE_BILL_INFO WHERE ID=A.BILL_ID) AS BILL_ACPT_BANK_NO,
 A.INTEREST AS INTEREST,D.PROV_INTEREST AS DRAW_INTEREST,D.REMA_INTEREST AS NO_DRAW_INTEREST,
 A.REMITTER AS BILL_REMITTER_NAME, A.REMITTER_ACCT_NO AS BILL_REMITTER_ACCT,
 (SELECT REMITTER_BANK_NO FROM TE_BILL_INFO WHERE ID=A.BILL_ID) AS BILL_REMITTER_BANK_NO,
 (SELECT PAYEE FROM TE_BILL_INFO WHERE ID=A.BILL_ID) AS BILL_PAYEE_NAME, 
 (SELECT PAYEE_ACCT_NO FROM TE_BILL_INFO WHERE ID=A.BILL_ID) AS BILL_PAYEE_ACCT, 
 (SELECT PAYEE_BANK_NO FROM TE_BILL_INFO WHERE ID=A.BILL_ID) AS BILL_PAYEE_BANK_NO, 
 (SELECT PAYEE_BANK_NAME FROM TE_BILL_INFO WHERE ID=A.BILL_ID) AS BILL_PAYEE_BANK_NAME, 
 (SELECT DRAWEE_BANK_NO FROM TE_BILL_INFO WHERE ID=A.BILL_ID) AS BILL_DRAWEE_BANK_NO,
 (SELECT DRAWEE_BANK_NAME FROM TE_BILL_INFO WHERE ID=A.BILL_ID) AS BILL_DRAWEE_BANK_NAME,
 B.IS_USE_CONTRACT AS IS_USE_CONTRACT
 
 FROM T_ACCT_HISTORY C,T_PROVISION D,TP_SALE_BILL_INFO A LEFT JOIN TP_SALE_BILL_BATCH B ON A.BATCH_ID=B.ID
WHERE A.ID=C.LIST_ID AND D.LIST_ID=C.LIST_ID AND SUBSTR(C.PROD_NO,1,3)='227' AND C.STATUS='1' 
