# COVID-19 Simulation

A code should be written to simulate COVID-19 infection in society. 

Below are rules that should help building a simulation model:
1. We assume that there are “N_population” citizens in a population. “N_population” is an input parameter. During development and testing you can have it small, but the code should be able to handle a reasonably large value for population size.
2. Every citizen has a health state – “healthy, sick, dead” (or you can code it as 0, 1, 2).
When we start, all citizens are alive and healthy.
3. To start the pandemic, you randomly mark a small number of citizens as “sick” – there can be a parameter for the number of initially infected citizens. You can start with 1 or 2 initial sick cases.
4. One iteration is one day. During the day, every citizen can meet a random number (say between 0 and 20 inclusive) of randomly selected citizens. You don’t really need to control all citizens as we are interested in meetings of sick people only. We don’t care how many healthy people meet each other.
5. Every sick citizen can stay sick and infectious for 10 days, hence you should have some counter for each sick citizen. After 10 days a sick citizen becomes healthy and stops spreading the virus.
6. Obviously, dead citizens cannot become sick, they don’t meet anyone and, as a result, cannot infect anyone.
7. During the day every sick citizen has a probability to die (mortality rate) from the disease with probability 0.5% (quite low probability).
8. If a sick citizen does not die, then they can meet other people as per the rule 4 above, and if they meet a healthy person, that person might become sick too and start infecting other people starting from the next day (that is an infection day is day 0 of their sickness). The probability for a citizen of becoming sick (infection rate) after a contact is 30% (this is quite high).
9. After surviving the infection and getting healthy, the person becomes immune. This is a partial immunity. It does not make the person “invincible” but reduces
the chance of infection in future meetings with sick people. Take the immunity coefficient as 0.1. That is, a probability of being infected for immune person is ten times lower than for the person without an immunity. The infection rate for the immune person is the “original” infection rate multiplied by the immunity coefficient, e.g. (0.3*0.1).
For the test, you can set immunity coefficient equal 1, which means no benefits of immunity and the result should be the same as in Python example I presented.
10. You should run this simulation for a number of days (iterations) and store each day results in a data frame: how many sick citizens in population in total, how many people died, how many new infections per day, something else you might find interesting or useful (e.g. R0). After completing the simulation, you should create a data visualisation of the history of infection.
11. You can run simulations for a predefined number of days, say 100 or 300 days, or till some natural outcome – all citizens get healthy, or all citizens die.
12. Try to change parameters of the model – increase mortality rate (more dangerous virus scenario – SARS and MERC had 3% mortality); or decrease infection rate (say, 5% – wearing masks and social distance scenario); or increase the length of sickness period; or reduce the number of possible contacts for all citizens to a range between 0 and 2 (lockdown scenario). Check what parameters have the strongest effect on the infection growth.
