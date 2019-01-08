RSA.java
import java.lang.*;
import java.math.BigInteger;
import java.util.Random;
import java.io.*;
public class RSAL {
public static void main(String args[]) throws IOException
{
	RSALAB rsa= new RSALAB();
	DataInputStream in=new DataInputStream(System.in);
	String teststring;
	System.out.println("enter the palin text:");
	teststring=in.readLine();
	BTS s1=new BTS();
	System.out.println("encrypting string:" + teststring);
	System.out.println("string in Bytes:"+s1.bytesToString(teststring.getBytes()));
	BTS s2=new BTS();
	byte[] encrypted=rsa.encrypt(teststring.getBytes());
	System.out.println("encrypted string:"+s2.bytesToString(encrypted));
	BTS s3=new BTS();
	byte[] decrypted=rsa.decrypt(encrypted);
	System.out.println("decrypted string:"+new String(decrypted));
}
}

BTS.java

public class BTS {
public String bytesToString(byte []encrypted)
{
	String test=" ";
	for(byte b:encrypted)
	{
		test +=Byte.toString(b);
	}
	return test;
}
}

RSALAB.java

import java.math.BigInteger;
import java.util.Random;
public class RSALAB {
	private BigInteger p;
	private BigInteger q;
	private BigInteger N;
	private BigInteger phi;
	private BigInteger e;
	private BigInteger d;
	private int bitlength=1024;
	private int blocksize=256;
	
	private Random r;
	public RSALAB(){
		r=new Random();
		p=BigInteger.probablePrime(bitlength,r);
		q=BigInteger.probablePrime(bitlength,r);
		N=p.multiply(q);
		phi=p.subtract(BigInteger.ONE).multiply(q.subtract(BigInteger.ONE));
		e=BigInteger.probablePrime(bitlength/2,r);
		while(phi.gcd(e).compareTo(BigInteger.ONE)>0 && e.compareTo(phi)<0)
		{
			e.add(BigInteger.ONE);
			
		}
		d=e.modInverse(phi);
		
	}
	public RSALAB(BigInteger e,BigInteger d, BigInteger N)
	{
		this.e=e;
		this.d=d;
		this.N=N;
		
	}
	public byte[] encrypt(byte[] message)
	{
		return(new BigInteger(message)).modPow(e,N).toByteArray();
	}
	public byte[] decrypt(byte[] message)
	{
		return(new BigInteger(message)).modPow(d,N).toByteArray();
	}
}
