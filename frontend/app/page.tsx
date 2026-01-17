const metrics = [
  { label: "Active Settlements", value: "1,042" },
  { label: "Compliance Holds", value: "12" },
  { label: "Bank Integrations", value: "4" }
];

const flows = [
  { id: "TX-91B4", status: "fiat_pending", amount: "$100,000" },
  { id: "TX-182D", status: "compliance_cleared", amount: "$42,500" },
  { id: "TX-55AA", status: "settling_on_chain", amount: "$18,900" }
];

export default function Home() {
  return (
    <main className="px-10 py-12">
      <header className="flex items-center justify-between">
        <div>
          <p className="text-sm uppercase tracking-[0.3em] text-aura-200">
            Project Aura
          </p>
          <h1 className="text-4xl font-semibold text-white">
            Settlement Command Center
          </h1>
        </div>
        <button className="rounded-full border border-aura-200 px-5 py-2 text-sm text-aura-200 hover:bg-aura-200 hover:text-aura-900">
          Pause Integration
        </button>
      </header>

      <section className="mt-10 grid gap-6 lg:grid-cols-3">
        {metrics.map((metric) => (
          <div
            key={metric.label}
            className="rounded-2xl bg-aura-800 p-6 shadow-lg"
          >
            <p className="text-sm text-aura-200">{metric.label}</p>
            <p className="mt-4 text-3xl font-semibold text-white">
              {metric.value}
            </p>
          </div>
        ))}
      </section>

      <section className="mt-12">
        <div className="flex items-center justify-between">
          <h2 className="text-2xl font-semibold text-white">Live Flows</h2>
          <span className="text-sm text-aura-200">Last refresh 12s</span>
        </div>
        <div className="mt-4 overflow-hidden rounded-2xl border border-aura-700">
          <table className="w-full text-left text-sm">
            <thead className="bg-aura-700/60 text-aura-200">
              <tr>
                <th className="px-6 py-4">Transaction</th>
                <th className="px-6 py-4">Status</th>
                <th className="px-6 py-4">Amount</th>
              </tr>
            </thead>
            <tbody>
              {flows.map((flow) => (
                <tr
                  key={flow.id}
                  className="border-t border-aura-700/60 text-white"
                >
                  <td className="px-6 py-4 font-medium">{flow.id}</td>
                  <td className="px-6 py-4">
                    <span className="rounded-full bg-aura-700 px-3 py-1 text-xs uppercase tracking-wide text-aura-100">
                      {flow.status}
                    </span>
                  </td>
                  <td className="px-6 py-4">{flow.amount}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </section>
    </main>
  );
}
