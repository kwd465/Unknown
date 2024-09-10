using UnityEngine;
using System.Collections;
using System.Globalization;
using System.Collections.Generic;
using System.Text.RegularExpressions;
using System.Text;
using Newtonsoft.Json;
using System.Linq;


namespace BH
{
    public static class Util
    {
        #region - gold text
        static System.Text.StringBuilder s_sb = new System.Text.StringBuilder();
        static string[] s_strs = new string[] {
        "", "a", "b", "c", "d", "e", "f", "g", "h", "i",
        "j", "k", "l", "m", "n", "o", "p", "q", "r", "s",
        "t", "u", "v", "w", "x", "y", "z", "A", "B", "C",
        "D", "E", "F", "G", "H", "I", "J", "K", "L", "M",
        "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W",
        "X", "Y", "Z" };


        public static string ToGoldText(this float _iGold)
        {
            return ToGoldText((double)_iGold);
        }


        public static string ToGoldText(this int _iGold)
        {
            return ToGoldText((double)_iGold);
        }

        public static string ToGoldText(this long _iGold)
        {
            return ToGoldText((double)_iGold);
        }
        public static string ToGoldText(this double _iGold)
        {
            s_sb.Length = 0;
            double tmpDb = _iGold;
            int count = 0;

            if (tmpDb <= 1000000 && tmpDb >= -1000000)
            {

            }
            else
            {
                while (tmpDb >= 1000 || tmpDb <= -1000)
                {
                    tmpDb *= 0.001;
                    count++;
                }
            }

            if (count >= s_strs.Length)
                count = s_strs.Length - 1;

            if (count == 0)
            {
                s_sb.AppendFormat("{0:#,##0}", (int)_iGold);
            }
            else
            {
                int lastInt = (int)tmpDb;
                double lastPreDouble = (tmpDb - lastInt) * 1000;
                int lastPreInt = Mathf.RoundToInt((float)lastPreDouble);
                //if (lastPreInt < 100)
                //{
                //    s_sb.AppendFormat("{0}{1}", lastInt, s_strs[count]);
                //}
                //else
                {
                    int lastPreInt100 = (int)(lastPreInt * 0.1);

                    if (lastPreInt100 < 0)
                        lastPreInt100 *= -1;

                    s_sb.AppendFormat("{0:#,##0}.{1}{2}", lastInt, lastPreInt100, s_strs[count]);
                }
            }

            return s_sb.ToString();
        }

        public static string GetGoldText_T1(int _iGold)
        {
            return GetGoldText_T1((long)_iGold);
        }

        public static string GetGoldText_T1(long _iGold)
        {
            return _iGold.ToString("#,#0", CultureInfo.InvariantCulture);
        }

        public static string GetGoldText_T1(ulong _iGold)
        {
            return _iGold.ToString("#,#0", CultureInfo.InvariantCulture);
        }

        public static string GetGoldText_T1(float _iGold)
        {
            return _iGold.ToString("#,#0", CultureInfo.InvariantCulture);
        }
        #endregion

        #region - random
        static public int GetRandomIdx(List<int> _list)
        {
            if (null == _list)
                return 0;

            int _ratetotal = 0;
            for (int i = 0; i < _list.Count; ++i)
            {
                _ratetotal += _list[i];
            }

            int _rate = 0;
            int _rand = Random.Range(0, _ratetotal);
            for (int i = 0; i < _list.Count; ++i)
            {
                _rate += _list[i];
                if (_rand < _rate)
                {
                    return i;
                }
            }

            return 0;
        }


        #endregion

        #region -spline
        static public Vector3 GetBezier3(Vector3 p1, Vector3 p2, Vector3 p3, float mu)
        {
            float mum1, mum12, mu2;
            Vector3 p;
            mu2 = mu * mu;
            mum1 = 1f - mu;
            mum12 = mum1 * mum1;
            p.x = p1.x * mum12 + 2 * p2.x * mum1 * mu + p3.x * mu2;
            p.y = p1.y * mum12 + 2 * p2.y * mum1 * mu + p3.y * mu2;
            p.z = p1.z * mum12 + 2 * p2.z * mum1 * mu + p3.z * mu2;
            return p;
        }

        static public Vector3 GetBezier4(Vector3 p1, Vector3 p2, Vector3 p3, Vector3 p4, float mu)
        {
            float mum1, mum13, mu3;
            Vector3 p;
            mum1 = 1 - mu;
            mum13 = mum1 * mum1 * mum1;
            mu3 = mu * mu * mu;
            p.x = mum13 * p1.x + 3 * mu * mum1 * mum1 * p2.x + 3 * mu * mu * mum1 * p3.x + mu3 * p4.x;
            p.y = mum13 * p1.y + 3 * mu * mum1 * mum1 * p2.y + 3 * mu * mu * mum1 * p3.y + mu3 * p4.y;
            p.z = mum13 * p1.z + 3 * mu * mum1 * mum1 * p2.z + 3 * mu * mu * mum1 * p3.z + mu3 * p4.z;
            return (p);
        }

        // 0f <= t <= 1f ( t = 0f -> p1, t = 1f ->p2 )
        static public Vector3 GetCatmullRomSpline(Vector3 p0, Vector3 p1, Vector3 p2, Vector3 p3, float t)
        {
            Vector3 ret = Vector3.zero;

            float t2 = t * t;
            float t3 = t2 * t;

            ret.x = 0.5f * ((2.0f * p1.x) +
            (-p0.x + p2.x) * t +
            (2.0f * p0.x - 5.0f * p1.x + 4 * p2.x - p3.x) * t2 +
            (-p0.x + 3.0f * p1.x - 3.0f * p2.x + p3.x) * t3);

            ret.y = 0.5f * ((2.0f * p1.y) +
            (-p0.y + p2.y) * t +
            (2.0f * p0.y - 5.0f * p1.y + 4 * p2.y - p3.y) * t2 +
            (-p0.y + 3.0f * p1.y - 3.0f * p2.y + p3.y) * t3);

            ret.z = 0.5f * ((2.0f * p1.z) +
            (-p0.z + p2.z) * t +
            (2.0f * p0.z - 5.0f * p1.z + 4 * p2.z - p3.z) * t2 +
            (-p0.z + 3.0f * p1.z - 3.0f * p2.z + p3.z) * t3);

            return ret;
        }
        #endregion

        #region -angle
        static public float UpAngle(Vector3 fwd, Vector3 targetDir)
        {
            float angle = Vector3.Angle(fwd, targetDir);
            if (AngleDir(fwd, targetDir, Vector3.forward) == -1)
            {
                angle = 360.0f - angle;
                if (angle > 359.9999f)
                    angle -= 360.0f;
                return angle;
            }

            return angle;
        }


        static public float ContAngle(Vector3 fwd, Vector3 targetDir)
        {
            float angle = Vector3.Angle(fwd, targetDir);

            if (AngleDir(fwd, targetDir, Vector3.forward) == -1)
            {
                angle = 360.0f - angle;
                if (angle > 359.9999f)
                    angle -= 360.0f;

                return angle;
            }

            return angle;
        }

        public static float ClampAngle(float angle, float min, float max)
        {
            if (angle < -360F)
                angle += 360F;
            if (angle > 360F)
                angle -= 360F;

            return Mathf.Clamp(angle, min, max);
        }

        static public int AngleDir(Vector3 fwd, Vector3 targetDir, Vector3 up)
        {
            Vector3 perp = Vector3.Cross(fwd, targetDir);
            float dir = Vector3.Dot(perp, up);

            if (dir > 0.0)
                return 1;
            else if (dir < 0.0)
                return -1;

            return 0;
        }

        public static bool IsSightDetect(Vector3 posCur, Quaternion rot, Vector3 posTarget, float fAngle)
        {
            Vector3 tempTargetDir = posTarget - posCur;
            Vector3 tempCurLook = rot * Vector3.forward;

            float t = Vector3.Angle(tempCurLook.normalized, tempTargetDir.normalized);
            if (t < fAngle)
            {
                return true;
            }

            return false;
        }
        #endregion

        #region -color
        public static string colorToHex(Color32 color)
        {
            string hex = color.r.ToString("X2") + color.g.ToString("X2") + color.b.ToString("X2");
            return hex;
        }

        public static Color hexToColor(string hex)
        {
            hex = hex.Replace("0x", "");//in case the string is formatted 0xFFFFFF
            hex = hex.Replace("#", "");//in case the string is formatted #FFFFFF
            byte a = 255;//assume fully visible unless specified in hex
            byte r = byte.Parse(hex.Substring(0, 2), System.Globalization.NumberStyles.HexNumber);
            byte g = byte.Parse(hex.Substring(2, 2), System.Globalization.NumberStyles.HexNumber);
            byte b = byte.Parse(hex.Substring(4, 2), System.Globalization.NumberStyles.HexNumber);
            //Only use alpha if the string has enough characters
            if (hex.Length == 8)
            {
                a = byte.Parse(hex.Substring(4, 2), System.Globalization.NumberStyles.HexNumber);
            }
            return new Color32(r, g, b, a);
        }

        #endregion

        #region -vector
        static public float GetVecDic_DY(Vector3 _pos1, Vector3 _pos2)
        {
            _pos1.y = 0f;
            _pos2.y = 0f;

            return Vector3.Distance(_pos1, _pos2);
        }

        static public Vector3 GetVecDir_DY(Vector3 _pos1, Vector3 _pos2)
        {
            _pos1.y = 0f;
            _pos2.y = 0f;

            return _pos1 - _pos2;
        }

        public static bool IsInAngle(Vector3 posCur, Quaternion rot, Vector3 posTarget, float fAngle)
        {
            Vector3 tempTargetDir = posTarget - posCur;
            Vector3 tempCurLook = rot * Vector3.forward;

            float t = Vector3.Angle(tempCurLook.normalized, tempTargetDir.normalized);
            if (t < fAngle)
            {
                return true;
            }

            return false;
        }
        #endregion


        static public float GetPercentage(float _value, float _percent, float _percentRatio = 1000f)
        {
            return _value * _percent / _percentRatio;
        }

        static public long GetBuildUpCost(int _grade)
        {
            if (_grade <= 0)
                return 0;

            double _a = 0.3;
            double _b = 50;
            double _x = (double)_grade;

            return (long)(1.0 / _a * _x * _b);
        }

        static public long GetBuildUpSell(int _grade)
        {
            if (_grade <= 0)
                return 0;

            double _a = 0.3;
            double _b = 60;
            double _x = (double)_grade;
            return (long)(1.0 / _a * _x * _b);
        }

        static public long GetTotalCost(int _grade)
        {
            long _total = 0;
            for (int i = 1; i <= _grade; ++i)
            {
                _total += GetBuildUpCost(i);
            }

            return _total;
        }

        static public long GetTotalSell(int _grade)
        {
            long _total = 0;
            for (int i = 1; i <= _grade; ++i)
            {
                _total += GetBuildUpSell(i);
            }

            return _total;
        }

        static public int GetBuildUpRate(int _grade)
        {
            if (_grade <= 0)
                return 10000;

            int _rate = 10000 - _grade * 130;
            if (_rate < 1)
                return 1;

            return _rate;
        }

        static public bool CheckLangPattern(string _msg)
        {
            string reg = ".*[a-zA-Z0-9°¡-ÆR¤¡-¤¾¤¿-¤Ó\u2e80-\u2eff\u31c0-\u31ef\u3200-\u32ff\u3400-\u4dbf\u4e00-\u9fbf\uf900-\ufaff].*";
            //string reg = @"^[a-zA-Z0-9°¡-ÆR¤¡-¤¾¤¿-¤Ó]*$";
            bool isCheck = Regex.IsMatch(_msg, reg);
            return isCheck;
        }

        static public bool IsValidEmail(string _email)
        {
            if (string.IsNullOrWhiteSpace(_email))
                return false;
            return Regex.IsMatch(_email,
                @"\A(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?)\Z", RegexOptions.IgnoreCase);
        }



        public static string Encrypt(string p_data, string _key)
        {
            byte[] Skey = System.Text.ASCIIEncoding.ASCII.GetBytes(_key);

            // ¾ÏÈ£È­ ¾Ë°í¸®ÁòÁß RC2 ¾ÏÈ£È­¸¦ ÇÏ·Á¸é RC¸¦
            // DES¾Ë°í¸®ÁòÀ» »ç¿ëÇÏ·Á¸é DESCryptoServiceProvider °´Ã¼¸¦ ¼±¾ðÇÑ´Ù.
            //RC2 rc2 = new RC2CryptoServiceProvider();
            System.Security.Cryptography.DESCryptoServiceProvider rc2 = new System.Security.Cryptography.DESCryptoServiceProvider();

            // ´ëÄªÅ° ¹èÄ¡
            rc2.Key = Skey;
            rc2.IV = Skey;

            // ¾ÏÈ£È­´Â ½ºÆ®¸²(¹ÙÀÌÆ® ¹è¿­)À»
            // ´ëÄªÅ°¿¡ ÀÇÁ¸ÇÏ¿© ¾ÏÈ£È­ ÇÏ±â¶§¹®¿¡ ¸ÕÀú ¸Þ¸ð¸® ½ºÆ®¸²À» »ý¼ºÇÑ´Ù.
            System.IO.MemoryStream ms = new System.IO.MemoryStream();

            //¸¸µé¾îÁø ¸Þ¸ð¸® ½ºÆ®¸²À» ÀÌ¿ëÇØ¼­ ¾ÏÈ£È­ ½ºÆ®¸² »ý¼º
            System.Security.Cryptography.CryptoStream cryStream = new System.Security.Cryptography.CryptoStream(ms, rc2.CreateEncryptor(), System.Security.Cryptography.CryptoStreamMode.Write);

            // µ¥ÀÌÅÍ¸¦ ¹ÙÀÌÆ® ¹è¿­·Î º¯°æ
            byte[] data = System.Text.Encoding.UTF8.GetBytes(p_data.ToCharArray());

            // ¾ÏÈ£È­ ½ºÆ®¸²¿¡ µ¥ÀÌÅÍ ¾¸
            cryStream.Write(data, 0, data.Length);
            cryStream.FlushFinalBlock();

            // ¾ÏÈ£È­ ¿Ï·á (stringÀ¸·Î ÄÁ¹öÆÃÇØ¼­ ¹ÝÈ¯)
            return System.Convert.ToBase64String(ms.ToArray());
        }

        public static string Decrypt(string p_data, string _key)
        {
            byte[] Skey = System.Text.ASCIIEncoding.ASCII.GetBytes(_key);
            // ¾ÏÈ£È­ ¾Ë°í¸®ÁòÁß RC2 ¾ÏÈ£È­¸¦ ÇÏ·Á¸é RC¸¦
            // DES¾Ë°í¸®ÁòÀ» »ç¿ëÇÏ·Á¸é DESCryptoServiceProvider °´Ã¼¸¦ ¼±¾ðÇÑ´Ù.
            //RC2 rc2 = new RC2CryptoServiceProvider();
            System.Security.Cryptography.DESCryptoServiceProvider rc2 = new System.Security.Cryptography.DESCryptoServiceProvider();

            // ´ëÄªÅ° ¹èÄ¡
            rc2.Key = Skey;
            rc2.IV = Skey;

            // ¾ÏÈ£È­´Â ½ºÆ®¸²(¹ÙÀÌÆ® ¹è¿­)À»
            // ´ëÄªÅ°¿¡ ÀÇÁ¸ÇÏ¿© ¾ÏÈ£È­ ÇÏ±â¶§¹®¿¡ ¸ÕÀú ¸Þ¸ð¸® ½ºÆ®¸²À» »ý¼ºÇÑ´Ù.
            System.IO.MemoryStream ms = new System.IO.MemoryStream();

            //¸¸µé¾îÁø ¸Þ¸ð¸® ½ºÆ®¸²À» ÀÌ¿ëÇØ¼­ ¾ÏÈ£È­ ½ºÆ®¸² »ý¼º
            System.Security.Cryptography.CryptoStream cryStream =
                              new System.Security.Cryptography.CryptoStream(ms, rc2.CreateDecryptor(), System.Security.Cryptography.CryptoStreamMode.Write);

            //µ¥ÀÌÅÍ¸¦ ¹ÙÀÌÆ®¹è¿­·Î º¯°æÇÑ´Ù.
            byte[] data = System.Convert.FromBase64String(p_data);

            //º¯°æµÈ ¹ÙÀÌÆ®¹è¿­À» ¾ÏÈ£È­ ÇÑ´Ù.
            cryStream.Write(data, 0, data.Length);
            cryStream.FlushFinalBlock();

            //¾ÏÈ£È­ ÇÑ µ¥ÀÌÅÍ¸¦ ½ºÆ®¸µÀ¸·Î º¯È¯ÇØ¼­ ¸®ÅÏ
            return System.Text.Encoding.UTF8.GetString(ms.GetBuffer());
        }

        public static string fnGetRandomString(int numLength)
        {
            string strResult = "";
            string strRandomChar = "qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM0123456789"; //·£´ýÀ¸·Î µé¾î°¥ ¹®ÀÚ ¹× ¼ýÀÚ 
            StringBuilder rs = new StringBuilder(); //¸Å°³º¯¼ö·Î ¹ÞÀº numLength¸¸Å­ µ¥ÀÌÅÍ¸¦ °¡Á® ¿Ã ¼ö ÀÖ½À´Ï´Ù. 
            for (int i = 0; i < numLength; i++)
            {
                rs.Append(strRandomChar[Random.Range(0, strRandomChar.Length)]);
            }

            strResult = rs.ToString();
            return strResult;
        }

        public static void DelectAllChild(Transform tr)
        {
            var Allchild = tr.GetComponentsInChildren<Transform>(true);
            for (int i = 1; i < Allchild.Length; i++)
            {
                GameObject.Destroy(Allchild[i].gameObject);
            }
        }

        /// <summary>
        /// È®·ü °è»ê ½Ç¼ö 1-100% ¸¸ºÐÀ²·Î º¯°æÇÏ¿© °è»ê
        /// </summary>
        /// <param name="percent"></param>
        /// <returns></returns>
        public static bool CheckRate(int percent)
        {
            float _result = Random.Range(0, 10000); //0~9999¼ýÀÚ ¹ÝÈ¯
            return _result < percent * 100;
        }
        /// <summary>
        /// È®·ü °è»ê 0~1f ¸¸ºÐÀ²·Î º¯°æÇÏ¿© °è»ê
        /// </summary>
        /// <param name="percent"></param>
        /// <returns></returns>
        public static bool CheckRate(float percent)
        {
            float _result = Random.Range(0, 10000f); //0~9999¼ýÀÚ ¹ÝÈ¯
            return _result < percent * 10000f;
        }

        public static string ToComma(this int value)
        {
            return value.ToString("#,##0");
        }
        public static string ToComma(this float value)
        {
            return value.ToString("#,##0");
        }
        public static string ToComma(this long value)
        {
            return value.ToString("#,##0");
        }

        public static string ToComma(this double value)
        {
            return value.ToString("#,##0");
        }

        public static string ToCommaN2(this float value)
        {
            return value.ToString("#,##0.##");
        }

        public static string ToCommaN2(this double value)
        {
            return value.ToString("#,##0.##");
        }


        public static string ToCommaN3(this float value)
        {
            return value.ToString("#,##0.###");
        }

        public static string ToCommaN3(this double value)
        {
            return value.ToString("#,##0.###");
        }

        public static string ToCommaF4(this float value)
        {
            double _result = System.Math.Round(value,5);
            return value.ToString("#,##0.####");
        }

        public static string ToPercent(this float value)
        {
            return string.Format("{0:0.##}%", value * 100);
        }
        
        public static string ToPercent(this double value)
        {
            return string.Format("{0:0.##}%", value * 100);
        }

        public static T CloneJson<T>(this T source)
        {
            // Don't serialize a null object, simply return the default for that object
            if (ReferenceEquals(source, null))
            {
                return default(T);
            }

            // initialize inner objects individually
            // for example in default constructor some list property initialized with some values,
            // but in 'source' these items are cleaned -
            // without ObjectCreationHandling.Replace default constructor values will be added to result
            var deserializeSettings = new JsonSerializerSettings { ObjectCreationHandling = ObjectCreationHandling.Replace };

            return JsonConvert.DeserializeObject<T>(JsonConvert.SerializeObject(source), deserializeSettings);
        }

        public static string ToJsonString(this object source)
        {
            if (source == null)
                return null;

            return JsonConvert.SerializeObject(source);
        }

       
        public static string ToLocalize(this int _key)
        {
            return TableControl.instance.GetText(_key);
        }

        public static System.DateTime ToDateTime(this string _time)
        {
            System.DateTime _dateTime = TimeControl.instance.ConvertToDateTime(0);
            if (string.IsNullOrEmpty(_time) == false) 
            {
                System.Globalization.CultureInfo _info = new CultureInfo("ko-KR");
               _dateTime = System.DateTime.Parse(_time, _info);
            }
            return _dateTime;
        }

        private const string KEY_CHARS =
         "0123456789abcdefghijklmnopqrstuvwxyz";

        public static string GenerateKey(int length = 6)
        {
            var sb = new System.Text.StringBuilder(length);
            var r = new System.Random();

            for (int i = 0; i < length; i++)
            {
                int pos = r.Next(KEY_CHARS.Length);
                char c = KEY_CHARS[pos];
                sb.Append(c);
            }

            return sb.ToString();
        }

        public static int CheckNetworkState()
        {
            if (Application.internetReachability == NetworkReachability.NotReachable)
            {
                //no internet
                return -1;
            }
            else if (Application.internetReachability == NetworkReachability.ReachableViaLocalAreaNetwork)
            {
                //WIFI
                return 0;
            }
            else if (Application.internetReachability == NetworkReachability.ReachableViaCarrierDataNetwork)
            {
                //LTE
                return 1;
            }

            return -1;
        }

        public static Color[] m_gradeColor = new Color[]{
            Color.white,
            Color.green,
            Color.cyan,
            Color.blue,
            Color.yellow,
            Color.red
        };

        public static Color GradeColor(int _subGrade)
        {
            return m_gradeColor[_subGrade - 1];
        }

        public static string GradeString(int _grade)
        {
            return string.Concat("T", _grade);
        }

        public static void CopyToClipboard(this string str)
        {
            GUIUtility.systemCopyBuffer = str;
            UIPopControl.instance.ShowToast("!À¯Àú¾ÆÀÌµð°¡ º¹»ç µÇ¾ú½À´Ï´Ù.");
        }

        public static bool IsOffScreen(Transform _tr)
        {
            Vector2 vec = Camera.main.WorldToViewportPoint(_tr.position);
            if (vec.x <= 1 && vec.y <= 1 && vec.x >= 0 && vec.y >= 0) // È­¸é ¾ÈÂÊ ¹üÀ§
                return false;
            else
                return true;
        }

        public static bool IsOffScreen(Transform _tr , float _height , float _width)
        {
            Vector2 vec = Camera.main.WorldToViewportPoint(_tr.position);
            if (vec.x <= 1 && vec.y <= 1 && vec.x >= 0 && vec.y >= 0) // È­¸é ¾ÈÂÊ ¹üÀ§
                return false;
            else
                return true;


            //Vector2 vec = _tr.position;

            //if (vec.y <= _height && vec.y >= 0 &&
            //    vec.x <= _width && vec.x >= 0)
            //    return false;
            //else
            //    return true;
        }

        public static bool isStat(this e_SkillEffectType _type)
        {
            bool _stat = false;
            switch (_type)
            {
                case e_SkillEffectType.atk:
                case e_SkillEffectType.def:
                case e_SkillEffectType.hp:
                case e_SkillEffectType.hpregen:
                case e_SkillEffectType.movespeed:
                case e_SkillEffectType.cri:
                case e_SkillEffectType.atks:
                    _stat = true;
                    break;

                default:
#if DEBUG_LOG
                    Debug.LogWarning("isStat NOT SUPPORT TYPE:" + _type);
#endif
                    break;
            }

            return _stat;
        }


        public static eSTAT ToParseStat(this e_SkillEffectType _type)
        {
            eSTAT _stat = eSTAT.atk;
            switch (_type)
            {
                case e_SkillEffectType.atk:
                    _stat = eSTAT.atk;
                    break;

                case e_SkillEffectType.def:
                    _stat = eSTAT.def;
                    break;

                case e_SkillEffectType.hp:
                    _stat = eSTAT.hp;
                    break;

                case e_SkillEffectType.hpregen:
                    _stat = eSTAT.hpregen;
                    break;

                case e_SkillEffectType.movespeed:
                    _stat = eSTAT.movespeed;
                    break;

                case e_SkillEffectType.cri:
                    _stat = eSTAT.cri;
                    break;

                case e_SkillEffectType.atks:
                    _stat = eSTAT.atks;
                    break;

                default:
#if DEBUG_LOG
                    Debug.LogWarning("ToParseStat NOT SUPPORT TYPE:" + _type);
#endif
                    break;
            }

            return _stat;
        }

        public static List<T> GetRandomList<T>(this List<T> list, int count)
        {
            if (list.Count <= count)
                return list;

            List<T> _result = new List<T>();
            List<T> _temp = new List<T>(list);

            for (int i = 0; i < count; i++)
            {
                int _index = Random.Range(0, _temp.Count);
                _result.Add(_temp[_index]);
                _temp.RemoveAt(_index);
            }

            return _result;
        }
    }



}