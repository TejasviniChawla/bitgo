import express from "express";

const app = express();
app.use(express.json());

const failureRate = Number(process.env.FAILURE_RATE ?? 0.2);
const delayMs = Number(process.env.DELAY_MS ?? 1200);

app.post("/transfers", async (req, res) => {
  await new Promise((resolve) => setTimeout(resolve, delayMs));

  if (Math.random() < failureRate) {
    return res.status(500).json({ error: "bank_unavailable" });
  }

  return res.status(200).json({
    bank_reference: `BANK-${Math.floor(Math.random() * 10_000)}`,
    received_amount: req.body.amount,
    currency: req.body.currency
  });
});

app.listen(4001, () => {
  console.log("Mock Bank API running on port 4001");
});
