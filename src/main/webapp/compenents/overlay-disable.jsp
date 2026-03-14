<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    Object disabledAttr = session.getAttribute("accountDisabled");
    boolean accountDisabled = disabledAttr instanceof Boolean && (Boolean) disabledAttr;
    if (accountDisabled) {
%>
<style>
    .account-disabled-overlay {
        position: fixed;
        inset: 0;
        background: rgba(0, 0, 0, 0.55);
        backdrop-filter: blur(2px);
        display: flex;
        align-items: center;
        justify-content: center;
        z-index: 10000;
        cursor: not-allowed;
    }

    .account-disabled-card {
        width: min(520px, calc(100% - 32px));
        background: #fff;
        color: #1f1f1f;
        padding: 28px 32px;
        border-radius: 12px;
        text-align: center;
        box-shadow: 0 18px 40px rgba(0, 0, 0, 0.25);
        cursor: default;
    }

    .account-disabled-card p {
        margin: 0;
        font-size: 16px;
        line-height: 1.6;
    }
</style>
<div class="account-disabled-overlay" role="alert" aria-live="assertive">
    <div class="account-disabled-card">
        <p>Tài khoản của bạn đã bị vô hiệu hóa. Nếu đây là sai sót xin vui lòng liên hệ support@nhom10.com</p>
    </div>
</div>
<%
    }
%>
