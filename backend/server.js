const express = require("express")
const sql = require("mssql")
const cors = require("cors")

const app = express()

app.use(cors())
app.use(express.json())

const dbConfig = {
    user: "sa",
    password: "tvoje_heslo",
    server: "localhost",
    database: "EshopElektronika",
    options: {
        encrypt: false,
        trustServerCertificate: true
    }
}

sql.connect(dbConfig)




app.get("/produkty", async (req, res) => {

    try {

        const result = await sql.query(`
            SELECT
                p.id_produkt,
                p.nazov,
                p.cena,
                p.sklad_mnozstvo
            FROM
                Produkty p
        `)

        res.json(result.recordset)

    } catch (err) {
        res.send(err)
    }

})



app.get("/produkty/cena/:cena", async (req, res) => {

    const cena = req.params.cena

    const result = await sql.query(`
        SELECT
            nazov,
            cena
        FROM
            Produkty
        WHERE
            cena < ${cena}
    `)

    res.json(result.recordset)

})



app.post("/produkt", async (req, res) => {

    const {nazov,cena,sklad_mnozstvo} = req.body

    await sql.query(`
        INSERT INTO Produkty
        (
            nazov,
            cena,
            sklad_mnozstvo
        )
        VALUES
        (
            '${nazov}',
            ${cena},
            ${sklad_mnozstvo}
        )
    `)

    res.send("Produkt pridaný")

})



app.listen(3000, () => {
    console.log("Server beží na porte 3000")
})