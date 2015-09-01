public class PriceCodesCsvhnadler {

    public String csvbody {get;set;}
    //public List<String> csvbody1{get;set;}
    public Integer kk {get;set;}
    public List < List < string >> lstContent {get;set;}
    List < string > currentrow = new List < string > ();
    public Map < String, Map < String, Map < String, List < MeteredType >>> > mapPriceCode{get;set;}
    public Map < String, Map < String, List < String >>> mapKeySet{get;set;}

    Boolean done = false;
    Integer j = 0;
    Integer k = 0;
    Integer i = 0;
    String line = '';


    public PriceCodesCsvhnadler() {
        try {
            List < Document > d = [Select body, bodyLength, ContentType, Url from Document where Name = 'Price Code'];
            lstContent = new List < List < string >> ();
            mapPriceCode = new Map < String, Map < String, Map < String, List < MeteredType >>> > ();
            if (d.size() > 0) {
                Blob b = d[0].body;
                csvbody = b.toString();
            }

            if (d.size() > 0) {
                Integer jj = 5;
                Map < String, Map < String, List < MeteredType >>> mapContent = new Map < String, Map < String, List < MeteredType >>> ();
                Map < String, List < MeteredType >> mapPriceCodeContent = new Map < String, List < MeteredType >> ();
                try {
                    while (!done) {
                        k = csvbody.indexOf('*EOL*', i);
                        kk = k;
                        line = csvbody.substring(i, k);
                        currentrow = line.split(',');
                        lstContent.add(currentrow);
                        String strOfficeName = currentrow.get(0).trim();
                        String strOfficePlusMeteredname = currentrow.get(1).trim();
                        String strMeteredPriceCodeName = currentrow.get(2).trim();

                        //kk=currentrow .size();
                        //csvbody1=currentrow ;
                        if (mapPriceCode.get(strOfficeName) != null) {
                            mapContent = mapPriceCode.get(strOfficeName);
                            if (mapContent.get(strOfficePlusMeteredname) != null) {
                                mapPriceCodeContent = mapContent.get(strOfficePlusMeteredname);
                                if (mapPriceCodeContent.get(strMeteredPriceCodeName) != null) {
                                    List < MeteredType > lstMeteredType = mapPriceCodeContent.get(strMeteredPriceCodeName);
                                    MeteredType obj = new MeteredType();
                                    obj.strMeteredType = currentrow.get(1).trim();
                                    obj.strPriceCodeHeader = strMeteredPriceCodeName;
                                    if (strMeteredPriceCodeName.contains('Metered Toll Free Price Codes') == true) {
                                        obj.isMetered = true;
                                    } else if (strMeteredPriceCodeName.contains('Metered Toll Free with Contract Price Codes') == true) {
                                        obj.isMetered = false;
                                    } else if (strMeteredPriceCodeName.contains('Unlimited Toll Free Price Codes') == true) {
                                        obj.isUnLimted = true;
                                    } else if (strMeteredPriceCodeName.contains('Unlimited Toll Free with Contract Price Codes') == true) {
                                        obj.isUnLimted = false;
                                    }
                                    obj.strMonthelyPricePerLineHeader = 'Monthly price per line';
                                    obj.strPriceCodeHeader = 'Price Code (OID=)';

                                    obj.strPriceCode = currentrow.get(3).trim();
                                    obj.strMonthelyPricePerLineValue = currentrow.get(4).trim();
                                    if (currentrow.size() >= 6) {
                                        obj.strPriceCodeValue = currentrow.get(5).trim();
                                    }
                                    lstMeteredType.add(obj);
                                    mapPriceCodeContent.put(strMeteredPriceCodeName, lstMeteredType);
                                    mapContent.put(strOfficePlusMeteredname, mapPriceCodeContent);
                                    mapPriceCode.put(strOfficeName, mapContent);
                                } else {
                                    List < MeteredType > lstMeteredType = new List < MeteredType > ();
                                    MeteredType obj = new MeteredType();
                                    obj.strMeteredType = currentrow.get(1).trim();
                                    obj.strPriceCodeHeader = strMeteredPriceCodeName;

                                    if (strMeteredPriceCodeName.contains('Metered') == true) {
                                        obj.isMetered = true;
                                    } else if (strMeteredPriceCodeName.contains('Unlimited') == true) {
                                        obj.isMetered = false;
                                    }
                                    obj.strMonthelyPricePerLineHeader = 'Monthly price per line';
                                    obj.strPriceCodeHeader = 'Price Code (OID=)';

                                    obj.strPriceCode = currentrow.get(3).trim();
                                    obj.strMonthelyPricePerLineValue = currentrow.get(4).trim();
                                    if (currentrow.size() >= 6) {
                                        obj.strPriceCodeValue = currentrow.get(5).trim();
                                    }

                                    lstMeteredType.add(obj);
                                    mapPriceCodeContent.put(strMeteredPriceCodeName, lstMeteredType);
                                    mapContent.put(strOfficePlusMeteredname, mapPriceCodeContent);
                                    mapPriceCode.put(strOfficeName, mapContent);
                                }
                            } else {
                                List < MeteredType > lstMeteredType = new List < MeteredType > ();
                                mapPriceCodeContent = new Map < String, List < MeteredType >> ();
                                MeteredType obj = new MeteredType();
                                obj.strMeteredType = currentrow.get(1).trim();
                                obj.strPriceCodeHeader = strMeteredPriceCodeName;
                                if (strMeteredPriceCodeName.contains('Metered Toll Free Price Codes') == true) {
                                    obj.isMetered = true;
                                } else if (strMeteredPriceCodeName.contains('Metered Toll Free with Contract Price Codes') == true) {
                                    obj.isMetered = false;
                                } else if (strMeteredPriceCodeName.contains('Unlimited Toll Free Price Codes') == true) {
                                    obj.isUnLimted = true;
                                } else if (strMeteredPriceCodeName.contains('Unlimited Toll Free with Contract Price Codes') == true) {
                                    obj.isUnLimted = false;
                                }


                                obj.strMonthelyPricePerLineHeader = 'Monthly price per line';
                                obj.strPriceCodeHeader = 'Price Code (OID=)';

                                obj.strPriceCode = currentrow.get(3).trim();
                                obj.strMonthelyPricePerLineValue = currentrow.get(4).trim();
                                if (currentrow.size() >= 6) {
                                    obj.strPriceCodeValue = currentrow.get(5).trim();
                                }

                                lstMeteredType.add(obj);
                                mapPriceCodeContent.put(strMeteredPriceCodeName, lstMeteredType);
                                mapContent.put(strOfficePlusMeteredname, mapPriceCodeContent);
                                //mapPriceCode.put(strOfficeName,mapContent);
                            }
                        } else {
                            List < MeteredType > lstMeteredType = new List < MeteredType > ();
                            mapContent = new Map < String, Map < String, List < MeteredType >>> ();
                            mapPriceCodeContent = new Map < String, List < MeteredType >> ();

                            MeteredType obj = new MeteredType();
                            obj.strMeteredType = currentrow.get(1).trim();
                            obj.strPriceCodeHeader = strMeteredPriceCodeName;
                            if (strMeteredPriceCodeName.contains('Metered Toll Free Price Codes') == true) {
                                obj.isMetered = true;
                            } else if (strMeteredPriceCodeName.contains('Metered Toll Free with Contract Price Codes') == true) {
                                obj.isMetered = false;
                            } else if (strMeteredPriceCodeName.contains('Unlimited Toll Free Price Codes') == true) {
                                obj.isUnLimted = true;
                            } else if (strMeteredPriceCodeName.contains('Unlimited Toll Free with Contract Price Codes') == true) {
                                obj.isUnLimted = false;
                            }

                            obj.strMonthelyPricePerLineHeader = 'Monthly price per line';
                            obj.strPriceCodeHeader = 'Price Code (OID=)';

                            obj.strPriceCode = currentrow.get(3).trim();
                            obj.strMonthelyPricePerLineValue = currentrow.get(4).trim();
                            if (currentrow.size() >= 6) {
                                obj.strPriceCodeValue = currentrow.get(currentrow.size() - 1).trim();
                            }
                            lstMeteredType.add(obj);
                            mapPriceCodeContent.put(strMeteredPriceCodeName, lstMeteredType);
                            mapContent.put(strOfficePlusMeteredname, mapPriceCodeContent);
                            mapPriceCode.put(strOfficeName, mapContent);

                        }
                        if (k == csvbody.lastIndexOf('*EOL*')) {
                            done = true;
                        } else {
                            i = k + 6;
                        }
                        jj--;
                    }
                    Set < String > strKeySet = new Set < String > ();
                    Map < String, List < String >> map2;
                    List < String > lstKeySet;
                    if (mapPriceCode != null && mapPriceCode.size() > 0) {
                        mapKeySet = new Map < String, Map < String, List < String >>> ();
                        strKeySet = mapPriceCode.keySet();
                        for (String str: strKeySet) {
                            map2 = new Map < String, List < String >> ();
                            for (String str2: mapPriceCode.get(str).keySet()) {
                                lstKeySet = new List < String > ();
                                for (String str3: mapPriceCode.get(str).get(str2).keySet()) {
                                    lstKeySet.add(str3);
                                }
                                lstKeySet.sort();
                                map2.put(str2, lstKeySet);
                            }
                            mapKeySet.put(str, map2);
                        }
                    }
                } catch (Exception e) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Invalid csv format'));
                }
            } else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'File not found'));
            }
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, e.getMessage()));
        }
    }
    private class MeteredType {
        public String strMeteredType {get;set;}
        public String strPriceCodeHeader{get;set;}
        public String strPriceCode{get;set;}
        public String strMonthelyPricePerLineHeader {get;set;}
        public String strMonthelyPricePerLineValue{get;set;}
        public String strPriceCodeValue {get;set;}
        public Boolean isMetered {get;set;}
        public Boolean isUnLimted{get;set;}
    }
}