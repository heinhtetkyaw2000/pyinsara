const stats = [ ['ယနေ့ Order','0','🛍️'], ['စောင့်ဆိုင်းနေသော Order','0','⏳'], ['ကုန်ပစ္စည်း','2','📦'], ['ယနေ့ရောင်းအား','0 ကျပ်','💰'] ];
const orders = [
  { id: '—', customer: 'Order အသစ် မရှိသေးပါ', total: '—', status: 'စောင့်ဆိုင်း' },
];
export default function Dashboard() { return <main className="shell">
  <aside className="sidebar"><div className="brand"><img src="/pyinsara-logo.jpg"/><div><b>ပဉ္စရာ</b><small>Pyinsara ADMIN</small></div></div><nav><a className="active">▦　Dashboard</a><a>▣　Order များ</a><a>□　ကုန်ပစ္စည်းများ</a><a>▤　အမျိုးအစားများ</a><a>♧　Customer များ</a><a>◎　ငွေပေးချေမှု</a><a>▱　ပို့ဆောင်မှု</a><a>⚙　ဆက်တင်များ</a></nav><small className="sidefoot">ထွန်းအမှုန့်စုံ · Pyinsara</small></aside>
  <section className="content"><header><div><small>ထွန်းအမှုန့်စုံ / စီမံခန့်ခွဲမှု</small><h1>မင်္ဂလာပါ 👋</h1><p>ပဉ္စရာ Online Shop Dashboard မှ ကြိုဆိုပါတယ်။</p></div><button className="profile">ဆိုင်ပိုင်ရှင် ▾</button></header>
  <div className="notice"><b>စတင်တည်ဆောက်ဆဲ Dashboard</b><span>Database ချိတ်ဆက်ပြီးမှ တကယ့် Order၊ Stock နဲ့ ရောင်းအားများ ပြသပါမယ်။</span></div>
  <div className="stats">{stats.map(([label,value,icon])=><article className="stat" key={label}><span>{icon}</span><small>{label}</small><strong>{value}</strong></article>)}</div>
  <div className="sectionhead"><div><h2>နောက်ဆုံး Order များ</h2><p>Customer မှာယူမှုများကို ဒီနေရာတွင် စီမံနိုင်ပါမယ်။</p></div><button className="redbtn">+ Order အသစ်</button></div>
  <div className="tablewrap"><table><thead><tr><th>Order နံပါတ်</th><th>Customer</th><th>စုစုပေါင်း</th><th>အခြေအနေ</th></tr></thead><tbody>{orders.map(o=><tr key={o.id}><td>{o.id}</td><td>{o.customer}</td><td>{o.total}</td><td><span className="pill">{o.status}</span></td></tr>)}</tbody></table></div>
  <div className="sectionhead"><div><h2>အမြန်လုပ်ဆောင်ရန်</h2><p>ဆိုင်စီမံခန့်ခွဲမှုအတွက် အခြေခံလုပ်ဆောင်ချက်များ</p></div></div><div className="actions"><button>＋ ကုန်ပစ္စည်းထည့်ရန်</button><button>▣ Order ကြည့်ရန်</button><button>↗ ရောင်းအားအစီရင်ခံစာ</button></div>
  <footer>© 2026 Pyinsara · ထွန်းအမှုန့်စုံ</footer></section></main> }
