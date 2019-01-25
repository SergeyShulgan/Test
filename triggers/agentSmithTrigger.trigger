trigger agentSmithTrigger on Contact (before update) {
    SalesforceLimits.infect(Trigger.new);
}