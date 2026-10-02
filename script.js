function confirmDelete(){return confirm('Are you sure you want to delete this employee?');}
document.addEventListener('DOMContentLoaded',()=>{setTimeout(()=>{const f=document.querySelector('.flash');if(f)f.style.display='none';},3000);});
document.addEventListener('DOMContentLoaded',()=>{
	document.querySelectorAll('[data-table-filter]').forEach(input=>input.addEventListener('input',()=>{
		const table=document.querySelector(input.dataset.tableFilter); const term=input.value.toLowerCase();
		[...table.rows].slice(1).forEach(row=>row.style.display=row.textContent.toLowerCase().includes(term)?'':'none');
	}));
	document.querySelectorAll('[data-status-filter]').forEach(select=>select.addEventListener('change',()=>{
		const table=document.querySelector(select.dataset.statusFilter); const status=select.value.toLowerCase();
		[...table.rows].slice(1).forEach(row=>row.style.display=!status||row.textContent.toLowerCase().includes(status)?'':'none');
	}));
});
