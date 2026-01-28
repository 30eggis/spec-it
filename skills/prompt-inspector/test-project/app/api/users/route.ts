import { NextResponse } from 'next/server';

// GET /api/users - 사용자 목록 조회
export async function GET() {
  const users = [
    { id: 1, name: '김철수', email: 'kim@example.com' },
    { id: 2, name: '이영희', email: 'lee@example.com' },
  ];
  return NextResponse.json(users);
}

// POST /api/users - 사용자 생성
export async function POST(request: Request) {
  const body = await request.json();
  return NextResponse.json({ id: 3, ...body }, { status: 201 });
}

// DELETE /api/users - 사용자 삭제
export async function DELETE(request: Request) {
  const { searchParams } = new URL(request.url);
  const id = searchParams.get('id');
  return NextResponse.json({ deleted: id });
}
