public with sharing class CustomSettingController {

    public String OutputCode { get; set;}
    public String FourNumber { get; set; }
    public String Letters { get; set; }
    public String RegionNumber { get; set; }
    public List<User> NumberAllUser { get; set; }
    final String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    public User CurrentUser { get; set; }
    public List <CustomSettingsMetadataType2__mdt> RegionCodes { get; set; }
    public Integer counterUniqueCode { get; set; }

    public String TestingPer { get; set; }

    public CustomSettingController() {
        OutputCode = 'this generate code';
    }

    public void GenerateCode() {
        User CurrentUser = [SELECT Id, Auto_Number__c, City  FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];

        RegionCodes = [
                SELECT MasterLabel,
                        CustomSettingsMetadataType1__r.RegionCode__c
                FROM CustomSettingsMetadataType2__mdt
                WHERE MasterLabel =: CurrentUser.City
        ];

        RegionNumber = GenerateRegionCode(CurrentUser.City);
        if (RegionNumber == null) { return; }
        Letters = GenerateLetters(UserInfo.getUserId());
        FourNumber = GenerateNumber();
        OutputCode = FourNumber + ' ' + Letters + '-' + RegionNumber;
    }

    public void SaveCode() {
        User CurrentUser = [SELECT Id, Auto_Number__c  FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
        if (CurrentUser.Auto_Number__c == null) {
            CurrentUser.Auto_Number__c = OutputCode;
            update CurrentUser;
        }
    }

    public String GenerateRegionCode(String City) {

        if (City == null) {
            OutputCode = 'City not found';
            return null;
        } else {
            String CurrentRegionCode = '';

            for (CustomSettingsMetadataType2__mdt Code : RegionCodes) {
                if (City == Code.MasterLabel) {
                    CurrentRegionCode = String.valueOf(Code.CustomSettingsMetadataType1__r.RegionCode__c);
                    break;
                }
            }

            if (CurrentRegionCode.length() == 0) {
                OutputCode = 'Region with code not found';
                return null;
            } else {
                return CurrentRegionCode;
            }
        }

    }

    public Boolean NullOrNot(SObject obj, String NameObj, String ErrorString, String FieldSearch) {

        if (obj.get(FieldSearch) == null) {
            OutputCode = ErrorString;
            return false;
        } else {
            return true;
        }

    }

    public String GenerateNumber() {

        String RandNumber = '';

        for (Integer i = 0; i < 4; i++) {
            RandNumber += ((math.random() * 10).intValue());
        }

        return RandNumber;

    }

    public String GenerateLetters(Id UserId) {

        String RandLetters = '';
        RandLetters = CustomSettingHierarhy__c.getInstance(UserId).LettersCode__c;

        if (RandLetters.length() == 0) {
            while (RandLetters.length() < 2) {
                Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
                RandLetters += chars.substring(idx, idx+1);
            }
        }

        return RandLetters;

    }

    public Boolean UniqueNumber(String ThisNumber) {

        for (User OneUser : NumberAllUser) {
            if (ThisNumber == OneUser.Auto_Number__c) {
                return false;
            }
        }

        return true;
    }

    public void DeleteCodeForUser() {

        User CurrentUser = [SELECT Id, Auto_Number__c  FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];

        if (CurrentUser.Auto_Number__c != null) {
            CurrentUser.Auto_Number__c = null;
            update CurrentUser;
        }

    }

    public void GenerateCodeForAllUser() {

        NumberAllUser = [SELECT Id, Auto_Number__c, City FROM User WHERE id != '0056F00000AoGQrQAN']; // I Haven't got access to user 0056F00000AoGQrQAN. This code in 2 places

        List <String> Cityes = new List<String>();

        for (User us : NumberAllUser) {
            Cityes.add(us.City);
        }

        RegionCodes = [
                SELECT MasterLabel,
                    CustomSettingsMetadataType1__r.RegionCode__c
                FROM CustomSettingsMetadataType2__mdt
                WHERE MasterLabel IN : Cityes
        ];

        for (User ThisUser : NumberAllUser) {

            if (ThisUser.Auto_Number__c != null) continue;

            RegionNumber = GenerateRegionCode(ThisUser.City);
            if (RegionNumber == null) continue;

            do {
                Letters = GenerateLetters(ThisUser.Id);
                FourNumber = GenerateNumber();
                OutputCode = FourNumber + ' ' + Letters + '-' + RegionNumber;

                counterUniqueCode = 0;

                for (User OneCode : NumberAllUser) {
                    if (OneCode.Auto_Number__c == OutputCode) {
                        counterUniqueCode++;
                    }
                }

            } while (counterUniqueCode != 0);

            ThisUser.Auto_Number__c = OutputCode;

        }
        update NumberAllUser;

    }

    public void DeleteCodesForAllUsers() {
        NumberAllUser = [SELECT Id, Auto_Number__c FROM User WHERE id != '0056F00000AoGQrQAN']; // I Haven't got access to user 0056F00000AoGQrQAN. This code in 2 places
        for (User us : NumberAllUser) {
            us.Auto_Number__c = null;
        }
        update NumberAllUser;
    }

}