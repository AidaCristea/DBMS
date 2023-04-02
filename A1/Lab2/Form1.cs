using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Data.SqlClient;

namespace Lab2
{
    public partial class Form1 : Form
    {
        SqlConnection con;
        SqlDataAdapter daAgent;
        SqlDataAdapter daCustomer;
        DataSet ds;
        BindingSource bsAgent;
        BindingSource bsCUstomer;

        string queryAgent;
        string queryCustomer;

        SqlCommandBuilder cmdBuilder;


        public Form1()
        {
            InitializeComponent();
            FillData();
            this.dataGridView2.CellValidating += new DataGridViewCellValidatingEventHandler(dataGridView2_CellValidating);

        }
        void FillData() // fill the form with the data from the database
        {
            con = new SqlConnection(getConnectionString());

            queryAgent = "SELECT * FROM Agent";
            queryCustomer = "SELECT * FROM Customer";

            //SqlDataAdapter, DataSet
            daAgent = new SqlDataAdapter(queryAgent, con);
            daCustomer = new SqlDataAdapter(queryCustomer, con);
            ds = new DataSet();
            daAgent.Fill(ds, "Agent"); //Parent
            daCustomer.Fill(ds, "Customer"); //Child

            //fill in the Insert, update, delete commands
            cmdBuilder = new SqlCommandBuilder(daCustomer);

            //parent then child

            //add the parent-child relationship to the daya set ds
            ds.Relations.Add("Agent_Customer",
                ds.Tables["Agent"].Columns["id_agent"],
                ds.Tables["Customer"].Columns["c_id_agent"]);

            //fill in the data in the gridView
            //Method1
            
            /*this.dataGridView1.DataSource = ds.Tables["Agent"];
            this.dataGridView2.DataSource = this.dataGridView1.DataSource;
            this.dataGridView2.DataMember = "Agent_Customer";*/


            //Method2: using the data binding
            bsAgent = new BindingSource();
            bsAgent.DataSource = ds.Tables["Agent"];
            bsCUstomer = new BindingSource(bsAgent, "Agent_Customer");

            this.dataGridView1.DataSource = bsAgent;
            this.dataGridView2.DataSource = bsCUstomer;

        }
    
        string getConnectionString()
        {
            return "Data Source=DESKTOP-HJ9L767;" +
                            "Initial Catalog = Travel Agency DB; Integrated Security=true;";
        }

        private void dataGridView2_CellValidating(object sender, DataGridViewCellValidatingEventArgs e)
        {
            if (e.ColumnIndex == 0) // ID column
            {
                int id;
                if (!int.TryParse(e.FormattedValue.ToString(), out id))
                {
                    e.Cancel = true;
                    MessageBox.Show("The ID must be a valid integer.");
                }
            }
        }

        private void button1_Click(object sender, EventArgs e)
        {
            try
            {
                daCustomer.Update(ds, "Customer");
                MessageBox.Show("Data uploaded successfully!");

            }
            catch(SqlException ex)
            {
                
                if(ex.Number == 2627) // validates the primary key; checks if it appears already or not
                {
                    MessageBox.Show("A customer with the same ID already exists");
                }
                else if (ex.Message.Contains("Cannot insert the value NULL into column"))
                {
                    MessageBox.Show("The ID field cannot be epmty. Please fill in the required field.");
                }
                else
                {
                    MessageBox.Show("An error occured while updating the data: " + ex.Message);
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("An error occured while updating the data: " + ex.Message);
            }
            
        }

        //add exceptions and validations
    } 
    
    
    

   


}
