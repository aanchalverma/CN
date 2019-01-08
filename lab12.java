import java.util.Scanner;

public class Leaky {

	public static void main(String args[])
	{
		Scanner sc=new Scanner(System.in);
		int bucket=0, op_rate,i,n,bsize;
		System.out.println("enter the number of packets");
		n=sc.nextInt();
		int pkt[]=new int[n];
		System.out.println("enter the output rate of bucket");
		op_rate=sc.nextInt();
		System.out.println("enter the bucket size:");
		bsize=sc.nextInt();
		System.out.println("enter the arriving packet(size)");
		for(i=0;i<n;i++)
			pkt[i]=sc.nextInt();
		System.out.println("\nsec\ntpsize\tBucket\tAccept/Reject\tpkt_send");
		System.out.println("-------------------------------------------------------------");
		for(i=0;i<n;i++)
		{
			System.out.print( i+1+"\t"+pkt[i]+"\t");
			if(bucket+pkt[i]<=bsize)
			{
				bucket+=pkt[i];
				System.out.print(bucket+"\tAccept\t\t"+min(bucket,op_rate)+"\n");
				bucket=sub(bucket,op_rate);
			}
			else
			{
				System.out.print(bucket+"\tReject"+(bucket+pkt[i]-bsize)+"\t"+min(bsize,op_rate)+"\n");
			bucket=bsize;
			bucket=sub(bucket,op_rate);
			
			}
		}
		while(bucket!=0)
		{
			System.out.print(i+++"\t o \t"+bucket+"Accept\t\t"+min(bucket,op_rate)+"\n");
			bucket=sub(bucket,op_rate);
			
		}
		sc.close();
		
	}
	static int min(int a,int b)
	{
		return(a<b) ?a:b;
		
	}
	static int sub(int a,int b)
	{
		return(a-b)>0?(a-b):0;
	}
}
