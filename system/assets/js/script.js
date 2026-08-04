// General JavaScript for the application
document.addEventListener('DOMContentLoaded', function() {
    // Enable Bootstrap tooltips
    const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    tooltipTriggerList.map(function (tooltipTriggerEl) {
        return new bootstrap.Tooltip(tooltipTriggerEl);
    });
    
    // Auto-dismiss alerts after 5 seconds
    const alerts = document.querySelectorAll('.alert');
    alerts.forEach(alert => {
        setTimeout(() => {
            alert.classList.add('fade');
            alert.classList.remove('show');
        }, 5000);
    });
    
    // Handle quantity changes in sales form
    document.querySelectorAll('.quantity-input').forEach(input => {
        input.addEventListener('change', function() {
            const row = this.closest('tr');
            const price = parseFloat(row.querySelector('.price').textContent);
            const quantity = parseInt(this.value);
            const totalCell = row.querySelector('.total');
            
            totalCell.textContent = (price * quantity).toFixed(2);
            updateInvoiceTotal();
        });
    });
    
    // Update invoice total
    function updateInvoiceTotal() {
        let total = 0;
        document.querySelectorAll('.total').forEach(cell => {
            total += parseFloat(cell.textContent);
        });
        document.getElementById('invoiceTotal').textContent = total.toFixed(2);
    }
    
    // Initialize datepickers
    if (typeof flatpickr !== 'undefined') {
        flatpickr('.datepicker', {
            dateFormat: 'Y-m-d',
            allowInput: true
        });
    }
});